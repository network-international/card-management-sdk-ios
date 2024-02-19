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
    // error TokenError
    func fetchToken() async throws -> NIAccessToken
    func clearToken()
}

public struct TokenFetcherFactory {
    public static func makeNetworkWithCache(urlString: String, credentials: NIClientCredentials, timeoutInterval: TimeInterval = 30) -> NICardManagementTokenFetchable {
        let storage = TokenKeychainStogage(credentials: credentials)
        let network = TokenNetworkFetcher(urlString: urlString, credentials: credentials, timeoutInterval: timeoutInterval)
        let repository = TokenRepository(tokenStorage: storage, networkFetcher: network)
        return repository
    }
    public static func makeSimpleWrapper(tokenValue: String, expiresIn: TimeInterval = 1800) -> NICardManagementTokenFetchable {
        TokenFetcherSimple.make(token: tokenValue, expiresIn: expiresIn)
    }
}
