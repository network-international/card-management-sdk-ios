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
        return try WebServices.createRequest(
            baseUrl: rootUrl.asURL,
            path: path,
            method: method,
            headers: headers,
            parameters: parameters,
            postQuery: queryParameters,
            token: token
        )
    }
    
}

