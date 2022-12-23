//
//  WebServices.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 10.10.2022.
//

import Foundation

enum WebServices {
    
    static func createRequest(_ baseUrl: URL, _ path: String, _ method: String, _ headers: Headers, _ token: String) -> URLRequest? {
        
        let authorization = "Bearer \(token)"
        let contentType = headers.contentType
        let accept = headers.accept
        
        let uniqueReferenceCode = headers.uniqueReferenceCode
        let financialId = headers.financialId
        let channelId = headers.channelId
        
        var request = URLRequest(url: baseUrl.appendingPathComponent(path))
        request.httpMethod = method
        request.setValue(authorization, forHTTPHeaderField: WSConstants.HeaderKeys.authorization)
        request.setValue(contentType, forHTTPHeaderField: WSConstants.HeaderKeys.contentType)
        request.setValue(accept, forHTTPHeaderField: WSConstants.HeaderKeys.accept)
        request.setValue(uniqueReferenceCode, forHTTPHeaderField: WSConstants.HeaderKeys.uniqueReferenceCode)
        request.setValue(financialId, forHTTPHeaderField: WSConstants.HeaderKeys.financialId)
        request.setValue(channelId, forHTTPHeaderField: WSConstants.HeaderKeys.channelId)
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
