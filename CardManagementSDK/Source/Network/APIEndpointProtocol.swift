//
//  APIEndpointProtocol.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 07.10.2022.
//

import Foundation

struct Headers {
    var contentType: String
    var accept: String
    var uniqueReferenceCode: String
    var financialId: String
    var channelId: String
}

enum WSHTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

protocol APIEndpointProtocol {
    var method: WSHTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any]? { get }      /// body & query parameters
    var queryParameters: [String: Any]? { get } /// to be used when query parameters are required on POST calls
    var headers: Headers { get }
    var token: String? { get }
    var rootUrl: String { get }
    func asURLRequest() throws -> URLRequest
}

private enum HeaderKeys {
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
    static let accept = "Accept"
    static let uniqueReferenceCode = "Unique-Reference-Code"
    static let financialId = "Financial-Id"
    static let channelId = "Channel-Id"
}



extension APIEndpointProtocol {
    
    func asURLRequest() throws -> URLRequest {
        guard
            let url = rootUrl.asURL?.appendingPathComponent(path), // Could not build the URL
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
        // postQuery
        queryParameters?.forEach({ (key, value) in
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
        request.setValue(authorization, forHTTPHeaderField: HeaderKeys.authorization)
        request.setValue(contentType, forHTTPHeaderField: HeaderKeys.contentType)
        request.setValue(accept, forHTTPHeaderField: HeaderKeys.accept)
        request.setValue(uniqueReferenceCode, forHTTPHeaderField: HeaderKeys.uniqueReferenceCode)
        request.setValue(financialId, forHTTPHeaderField: HeaderKeys.financialId)
        request.setValue(channelId, forHTTPHeaderField: HeaderKeys.channelId)
        //print("========== uniqueReferenceCode \(uniqueReferenceCode) =============")
        return request
    }
    
}

