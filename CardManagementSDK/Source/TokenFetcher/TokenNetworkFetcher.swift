//
//  TokenNetworkFetcher.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 20.12.2023.
//

import Foundation

// Simple network client
class TokenNetworkFetcher: NICardManagementTokenFetchable {
    private let urlRequest: URLRequest?
    private let credentials: ClientCredentials
    
    private let session: URLSession
    private let validStatus = 200...299
    private let decoder = JSONDecoder()
    private var task: URLSessionDataTask?
    
    init(urlString: String, credentials: ClientCredentials, timeoutInterval: TimeInterval = 30) {
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: timeoutInterval)
            urlRequest.httpMethod = WSHTTPMethod.POST.rawValue
            urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            var requestComponents = URLComponents()
            requestComponents.queryItems = [
                URLQueryItem(name: "client_id", value: credentials.clientId),
                URLQueryItem(name: "client_secret", value: credentials.clientSecret),
                URLQueryItem(name: "grant_type", value: "client_credentials")
            ]
            urlRequest.httpBody = requestComponents.query?.data(using: .utf8)
            
            self.urlRequest = urlRequest
        } else {
            self.urlRequest = nil
        }
        
        self.credentials = credentials
        let sessionConfig = URLSessionConfiguration.ephemeral // do not save anything
        session = URLSession(configuration: sessionConfig)
    }
    
    func fetchToken(completion: @escaping (Result<AccessToken, TokenError>) -> Void) {
        guard let urlRequest = urlRequest else {
            completion(.failure(TokenError.networkError(NSError.niError("bad url"))))
            return
        }
        task?.cancel()
        task = session.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, httpError in
            guard let self = self, let task = self.task, !task.progress.isCancelled else { return }
            if let httpError = httpError {
                completion(.failure(TokenError.networkError(httpError as NSError)))
                return
            }
            guard
                let httpResponse = response as? HTTPURLResponse,
                    self.validStatus.contains(httpResponse.statusCode)
            else {
                completion(.failure(TokenError.networkError(NSError.niError("invalid http status code \((response as? HTTPURLResponse)?.statusCode.description ?? "(no code)")"))))
                return
            }
            guard let data = data else {
                completion(.failure(TokenError.networkError(NSError.niError("no data received"))))
                return
            }
            do {
                let token = try self.decoder.decode(AccessToken.self, from: data)
                completion(.success(token))
            } catch {
                completion(.failure(TokenError.networkError(error)))
            }
        })
        task?.resume()
    }
    
    func clearToken() {
        task?.cancel()
        task = nil
    }
}
