//
//  TokenFetcherSimple.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 19.12.2023.
//

import Foundation

// Simple wrapper for token data
public class TokenFetcherSimple {
    public static func make(token: String, expiresIn: TimeInterval) -> Self {
        .init(tokenString: token, expiresIn: expiresIn)
    }
    
    private var tokenString: String
    private var expiresIn: TimeInterval
    
    required init(tokenString: String, expiresIn: TimeInterval) {
        self.tokenString = tokenString
        self.expiresIn = expiresIn
    }
}

extension TokenFetcherSimple: NICardManagementTokenFetchable {
    public func fetchToken() async throws -> NIAccessToken {
        NIAccessToken(value: tokenString, type: "bearer", expiresIn: expiresIn)
    }
    public func clearToken() {
        tokenString = ""
    }
}
