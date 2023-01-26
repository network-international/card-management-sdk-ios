//
//  Request.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation


class Request {
    
    var endpoint: APIEndpoint
    
    init(_ endpoint: APIEndpoint) {
        self.endpoint = endpoint
    }
    
    func sendAsync(_ completionHandler: @escaping (Response?, NIErrorResponse?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            do {
                guard let request = try self.endpoint.asURLRequest() else { return }
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    let res = Response(data: data, response: response, error: error as NSError?)
                    
                    DispatchQueue.main.async {
                        var error = NIErrorResponse()
                        error = error.withResponse(response: res) ?? error
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
