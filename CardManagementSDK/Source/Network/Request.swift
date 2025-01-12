//
//  Request.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation


class Request {
    
    var endpoint: APIEndpoint
    private let extraHeaders: [String: String]?
    
    init(_ endpoint: APIEndpoint, extraHeaders: [String: String]?) {
        self.endpoint = endpoint
        self.extraHeaders = extraHeaders
    }
    
    func sendAsync(_ completionHandler: @escaping (Response?, NIErrorResponse?) -> Void) {
        guard let request = endpoint.asURLRequest(extraHeaders: extraHeaders)
        else {
            DispatchQueue.main.async {
                completionHandler(nil, NIErrorResponse(error: .NETWORK_ERROR))
            }
            return
        }
        //logger.logRequestStarted(request)
        
        DispatchQueue.global(qos: .default).async {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                //self.logger.logRequestCompleted(request, response: response, data: data, error: error)
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
