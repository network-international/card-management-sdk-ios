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

class Request {
    
    var endpoint: APIEndpoint
    private let logger: RequestLogger
    
    init(_ endpoint: APIEndpoint, logger: RequestLogger) {
        self.endpoint = endpoint
        self.logger = logger
    }
    
    func sendAsync(_ completionHandler: @escaping (NIResponse?, NIErrorResponse?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            do {
                guard let request = try self.endpoint.asURLRequest() else { return }
                self.logger.logRequestStarted(request)
                let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                    self.logger.logRequestCompleted(request, response: response, data: data, error: error)
                    let res = NIResponse(data: data, response: response, error: error as NSError?)
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
                
            } catch {
                let error = NIErrorResponse(error: .NETWORK_ERROR)
                completionHandler(nil, error)
            }
        }
    }
    
}
