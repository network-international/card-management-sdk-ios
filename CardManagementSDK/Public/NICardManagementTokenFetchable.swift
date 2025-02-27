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
    var isRefreshable: Bool { get }
    func fetchToken(completion: @escaping (Result<AccessToken, TokenError>) -> Void)
    func clearToken()
}

public struct TokenFetcherFactory {
    public static func makeDemoClient(urlString: String, credentials: ClientCredentials, timeoutInterval: TimeInterval = 30) -> NICardManagementTokenFetchable {
        let storage = TokenKeychainStogage(credentials: credentials)
        let network = TokenNetworkFetcher(urlString: urlString, credentials: credentials, timeoutInterval: timeoutInterval)
        let repository = TokenRepository(tokenStorage: storage, networkFetcher: network)
        return repository
    }
    public static func makeSimpleWrapper(tokenValue: String, expiresIn: TimeInterval = 1800) -> NICardManagementTokenFetchable {
        TokenFetcherSimple.make(token: tokenValue, expiresIn: expiresIn)
    }
}
