//
//  WebServices.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 10.10.2022.
//

import Foundation

enum WebServices {
    
    static func createRequest(
        baseUrl: URL?,
        path: String,
        method: WSHTTPMethod,
        headers: Headers,
        parameters: [String: Any]?,
        postQuery: [String: Any]?,
        token: String?
    ) throws -> URLRequest {
        
        guard
            let url = baseUrl?.appendingPathComponent(path), // Could not build the URL
            let token = token, // Token is nil
            var urlComponents = URLComponents(
                url: url,
                resolvingAgainstBaseURL: true
            )
        else {
            throw NSError(domain: "MyDomain", code: 0)
        }
        
        var queryItems = [URLQueryItem]()
        var httpBody: Data?

        postQuery?.forEach({ (key, value) in
            queryItems.append(URLQueryItem(name: key, value: "\(value)"))
        })
         
        if let params = parameters, !params.isEmpty {
            if method == .GET {
                for (key, value) in params {
                    if let values = value as? [String] {
                        values.forEach { item in
                            queryItems.append(URLQueryItem(name: key, value: "\(item)"))
                        }
                    } else {
                        queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                    }
                }
            } else {
                let body = params.compactMapValues({ $0 })
                httpBody = JSON(from: body).toData()
            }
        }
        
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        
        guard
            let requestUrl = urlComponents.url
        else {
            throw NSError(domain: "MyDomain", code: 0)
        }
        var request = URLRequest(url: requestUrl)
        request.httpBody = httpBody
        
        let authorization = "Bearer \(token)"
        let contentType = headers.contentType
        let accept = headers.accept
        
        let uniqueReferenceCode = headers.uniqueReferenceCode
        let financialId = headers.financialId
        let channelId = headers.channelId
        
        request.httpMethod = method.rawValue
        request.setValue(authorization, forHTTPHeaderField: WSConstants.HeaderKeys.authorization)
        request.setValue(contentType, forHTTPHeaderField: WSConstants.HeaderKeys.contentType)
        request.setValue(accept, forHTTPHeaderField: WSConstants.HeaderKeys.accept)
        request.setValue(uniqueReferenceCode, forHTTPHeaderField: WSConstants.HeaderKeys.uniqueReferenceCode)
        request.setValue(financialId, forHTTPHeaderField: WSConstants.HeaderKeys.financialId)
        request.setValue(channelId, forHTTPHeaderField: WSConstants.HeaderKeys.channelId)
        //print("========== uniqueReferenceCode \(uniqueReferenceCode) =============")
        return request
    }
}


struct Headers {
    var contentType: String
    var accept: String
    var uniqueReferenceCode: String
    var financialId: String
    var channelId: String
}


private enum WSConstants {
    enum HeaderKeys {
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
        static let accept = "Accept"
        static let uniqueReferenceCode = "Unique-Reference-Code"
        static let financialId = "Financial-Id"
        static let channelId = "Channel-Id"
    }
    
}
