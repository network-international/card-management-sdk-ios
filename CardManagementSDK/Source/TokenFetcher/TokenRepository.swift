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
    public func fetchToken() async throws -> NIAccessToken {
        if let token = try? tokenStorage.getToken(), !token.isExpired {
            return token
        }
        return try await networkFetcher.fetchToken()
    }
    
    func clearToken() {
        tokenStorage.clearToken()
    }
}
