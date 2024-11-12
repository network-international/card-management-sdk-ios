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
        extraHeaders: [String: String]?,
        parameters: [String: Any]?,
        postQuery: [String: Any]?,
        token: String?
    ) -> URLRequest? {
        
        guard
            let url = baseUrl?.appendingPathComponent(path), // Could not build the URL
            let token = token, // Token is nil
            var urlComponents = URLComponents(
                url: url,
                resolvingAgainstBaseURL: true
            )
        else {
            return nil
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
            return nil
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
        request.setValue(authorization, forHTTPHeaderField: Headers.Key.authorization.rawValue)
        request.setValue(contentType, forHTTPHeaderField: Headers.Key.contentType.rawValue)
        request.setValue(accept, forHTTPHeaderField: Headers.Key.accept.rawValue)
        request.setValue(uniqueReferenceCode, forHTTPHeaderField: Headers.Key.uniqueReferenceCode.rawValue)
        request.setValue(financialId, forHTTPHeaderField: Headers.Key.financialId.rawValue)
        request.setValue(channelId, forHTTPHeaderField: Headers.Key.channelId.rawValue)
        
        extraHeaders?
            .filter { !Headers.Key.allCases.map(\.rawValue).contains($0.key) }
            .forEach {
                request.setValue($0.value, forHTTPHeaderField: $0.key)
            }
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
    
    fileprivate enum Key: String, CaseIterable {
        case authorization = "Authorization"
        case contentType = "Content-Type"
        case accept = "Accept"
        case uniqueReferenceCode = "Unique-Reference-Code"
        case financialId = "Financial-Id"
        case channelId = "Channel-Id"
    }
}
