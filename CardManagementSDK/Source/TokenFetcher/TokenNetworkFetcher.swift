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
    private let credentials: NIClientCredentials
    
    private let session: URLSession
    private let validStatus = 200...299
    private let decoder = JSONDecoder()
    
    init(urlString: String, credentials: NIClientCredentials, timeoutInterval: TimeInterval) {
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
    
    public func fetchToken() async throws -> NIAccessToken {
        guard let urlRequest = urlRequest else {
            throw TokenError.networkError(NSError.niError("bad url"))
        }
        let result: (data: Data, response: URLResponse)
        do {
            result = try await session.data(for: urlRequest)
        } catch {
            throw TokenError.networkError(error as NSError)
        }
        
        guard
            let httpResponse = result.response as? HTTPURLResponse,
                self.validStatus.contains(httpResponse.statusCode)
        else {
            throw TokenError.networkError(NSError.niError("invalid http status code \((result.response as? HTTPURLResponse)?.statusCode.description ?? "(no code)")"))
        }
        do {
            let token = try self.decoder.decode(NIAccessToken.self, from: result.data)
            return token
        } catch {
            throw TokenError.networkError(error)
        }
    }
    
    func clearToken() {}
}
