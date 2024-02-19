//
//  TokenStorage.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 19.12.2023.
//

import Foundation
import Security

protocol TokenStorage {
    func saveToken(_ token: NIAccessToken) throws
    func getToken() throws -> NIAccessToken?
    func clearToken()
}

class TokenInMemoryStogage: TokenStorage {
    private let cache: NSCache<NSString, NSData>
    private let key: NSString
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        key = "TokenInMemory"
        cache = NSCache()
        cache.countLimit = 1
    }
    
    // MARK: - TokenStorage
    func saveToken(_ token: NIAccessToken) throws {
        let encoded = try encoder.encode(token)
        cache.setObject(encoded as NSData, forKey: key)
    }
    
    func getToken() throws -> NIAccessToken? {
        guard let savedData = cache.object(forKey: key) as? Data else { return nil }
        let token = try decoder.decode(NIAccessToken.self, from: savedData)
        return token
    }
    
    func clearToken() {
        cache.removeAllObjects()
    }
}

class TokenKeychainStogage: TokenStorage {
    enum KeychainStogageError: Error {
        case saveError
    }
    
    private let credentials: NIClientCredentials
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private var accountAttr: String {
        "\(credentials.clientId):\(credentials.clientSecret)"
    }
    
    init(credentials: NIClientCredentials) {
        self.credentials = credentials
    }
    
    // MARK: - TokenStorage
    func saveToken(_ token: NIAccessToken) throws {
        let encoded = try encoder.encode(token)
        
        // check if saved and update
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrAccount as String: accountAttr]
        let updateAttrs: [String: Any] = [kSecValueData as String: encoded]
        var status = SecItemUpdate(query as CFDictionary, updateAttrs as CFDictionary)
        if status == noErr { return }
        // save new
        // tag your item using the kSecAttrLabel attribute to find it easier later on.
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accountAttr,
            kSecValueData as String: encoded,
        ]
        status = SecItemAdd(attributes as CFDictionary, nil)
        if status != noErr {
            throw KeychainStogageError.saveError
        }
    }
    
    func getToken() throws -> NIAccessToken? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accountAttr,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ] as CFDictionary
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)
        guard status == noErr else {
            // throw KeychainStorageError.unhandledError(status)
            return nil // no accountAttr in keychain
        }
        guard
            let existingItem = item as? [String: Any],
            let savedData = existingItem[kSecValueData as String] as? Data
        else { return nil }

        let token = try decoder.decode(NIAccessToken.self, from: savedData)
        return token
    }
    
    func clearToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: accountAttr,
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status != noErr {
            // throw KeychainStorageError.unhandledError(status)
        }
    }
}
