//
//  TokenFetcherSimple.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 19.12.2023.
//

import Foundation

// Simple wrapper for token data
public class TokenFetcherSimple {
    public static func make(token: String) -> Self {
        .init(tokenString: token)
    }
    
    private var tokenString: String
    
    required init(tokenString: String) {
        self.tokenString = tokenString
    }
}

extension TokenFetcherSimple: NICardManagementTokenFetchable {
    public func fetchToken(completion: @escaping (Result<AccessToken, TokenError>) -> Void) {
        let token = AccessToken(value: tokenString, type: "bearer", expiresIn: 3600)
        DispatchQueue.main.async { completion(.success(token)) }
    }
    public func clearToken() {
        tokenString = ""
    }
}
