//
//  Request.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation

protocol RequestLogger {
    func logRequestStarted(_ request: URLRequest)
    func logRequestCompleted(_ request: URLRequest, response: URLResponse?, data: Data?, error: Error?)
}

protocol RequestExtraHeadersProvider {
    func extraHeaders() -> [String: String]
}

class Request {
    
    var endpoint: APIEndpoint
    private let extraHeaders: [String: String]?
    private let logger: RequestLogger
    
    init(_ endpoint: APIEndpoint, extraHeaders: [String: String]?, logger: RequestLogger) {
        self.endpoint = endpoint
        self.extraHeaders = extraHeaders
        self.logger = logger
    }
    
    func sendAsync(_ completionHandler: @escaping (Response?, NIErrorResponse?) -> Void) {
        guard let request = endpoint.asURLRequest(extraHeaders: extraHeaders)
        else {
            DispatchQueue.main.async {
                completionHandler(nil, NIErrorResponse(error: .NETWORK_ERROR))
            }
            return
        }
        logger.logRequestStarted(request)
        
        DispatchQueue.global(qos: .default).async {
            let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                self.logger.logRequestCompleted(request, response: response, data: data, error: error)
                let res = Response(data: data, response: response, error: error as NSError?)
                var error = NIErrorResponse()
                error = error.withResponse(response: res) ?? error
                DispatchQueue.main.async {
                    if error.isError {
                        completionHandler(nil, error)
                    } else {
                        completionHandler(res, nil)
                    }
                }
            }
            task.resume()
        }
    }
    
}
