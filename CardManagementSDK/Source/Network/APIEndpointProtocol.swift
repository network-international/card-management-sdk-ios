//
//  APIEndpointProtocol.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 07.10.2022.
//

import Foundation


protocol APIEndpointProtocol {
    var method: WSHTTPMethod { get }
    var path: String { get }
    var parameters: [String: Any]? { get }      /// body & query parameters
    var queryParameters: [String: Any]? { get } /// to be used when query parameters are required on POST calls
    var headers: Headers { get }
    var token: String? { get }
    var rootUrl: String { get }
    func asURLRequest() throws -> URLRequest?
}

extension APIEndpointProtocol {
    
    func asURLRequest() throws -> URLRequest? {
        guard let baseUrl = rootUrl.asURL else {
            // Could not build the URL
            throw NSError(domain: "MyDomain", code: 0)
        }
        guard var urlComponents = URLComponents(string: rootUrl) else {
            throw NSError(domain: "MyDomain", code: 0)
        }
        guard let token = token else {
            // Token is nil
            throw NSError(domain: "MyDomain", code: 0)
        }
        
        urlComponents.path = "\(path)"
        
        var request: URLRequest?
        request = WebServices.createRequest(baseUrl, path, method.rawValue, headers, token)
        
        if let params = self.parameters, !params.isEmpty {
            if method != .GET {
                let body = params.compactMapValues({ $0 })
                request?.httpBody = JSON(from: body).toData()
                
                if let queryParameters = self.queryParameters {
                    var queryItems = [URLQueryItem]()
                    for (key, value) in queryParameters {
                        queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                        urlComponents.queryItems = queryItems
                    }
                }
                
            } else {
                var queryItems = [URLQueryItem]()
                for (key, value) in params {
                    
                    if value is Array<String> {
                        for item in value as! Array<String> {
                            queryItems.append(URLQueryItem(name: key, value: "\(item)"))
                        }
                    } else {
                        queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                    }
                }
                
                urlComponents.queryItems = queryItems
                request?.url? = urlComponents.url!
                
            }
        }
        
        return request ?? nil
    }
    
}

