//
//  NICardManagementTokenFetchable.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 19.12.2023.
//

import Foundation

public enum TokenError: Error {
    case networkError(Error)
    case unknown
}

public protocol NICardManagementTokenFetchable {
    func fetchToken(completion: @escaping (Result<AccessToken, TokenError>) -> Void)
    func clearToken()
}

public struct TokenFetcherFactory {
    public static func makeNetworkWithCache(urlString: String, credentials: ClientCredentials) -> NICardManagementTokenFetchable {
        let storage = TokenKeychainStogage(credentials: credentials)
        let network = TokenNetworkFetcher(urlString: urlString, credentials: credentials, timeoutInterval: 30)
        let repository = TokenRepository(tokenStorage: storage, networkFetcher: network)
        return repository
    }
    public static func makeSimpleWrapper(tokenValue: String) -> NICardManagementTokenFetchable {
        TokenFetcherSimple.make(token: tokenValue)
    }
}
