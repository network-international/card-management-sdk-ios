//
//  TokenNetworkFetcher.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 19.12.2023.
//

import Foundation

class TokenRepository {
    private let tokenStorage: TokenStorage
    private let networkFetcher: NICardManagementTokenFetchable
    
    required init(tokenStorage: TokenStorage, networkFetcher: NICardManagementTokenFetchable) {
        self.tokenStorage = tokenStorage
        self.networkFetcher = networkFetcher
    }
}

extension TokenRepository: NICardManagementTokenFetchable {
    func fetchToken(completion: @escaping (Result<AccessToken, TokenError>) -> Void) {
        if let token = try? tokenStorage.getToken(), !token.isExpired {
            DispatchQueue.main.async { completion(.success(token)) }
            return
        }
        networkFetcher.fetchToken { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .failure(tokenError):
                    completion(.failure(tokenError))
                case let .success(token):
                    try? self?.tokenStorage.saveToken(token)
                    completion(.success(token))
                }
            }
        }
    }
    
    func clearToken() {
        tokenStorage.clearToken()
    }
}
