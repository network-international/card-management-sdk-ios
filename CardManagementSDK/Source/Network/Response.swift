//
//  Response.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation

struct ResponseConstants {
    static let ErrorJson = "Unexpected error trying to parse Data to Json"
    static let message = "message"
}

class Response {
    
    var code: Int
    var error: NSError?
    var data: Data?
    var url: URL?
    var body: JSON?
    var headers: [String: String]?
    
    init(data: Data?, response: URLResponse?, error: NSError?) {
        self.data = data
        self.code = -1
        
        do {
            guard let response = response as? HTTPURLResponse else {
                throw error ?? NSError.unexpectedError()
            }
            self.url = response.url
            self.code = response.statusCode
            self.headers = response.allHeaderFields as? [String: String]
            
            
            if let unwrappedData = data, let json = try? JSON.dataToJson(unwrappedData) {
                self.body = json
            }
            
        } catch let error as NSError {
            self.code = error.code
            self.error = error
        }
    }
}
