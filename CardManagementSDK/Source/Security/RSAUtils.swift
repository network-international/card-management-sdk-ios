//
//  RSAUtils.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 21.10.2022.
//

import Foundation


class RSAUtils {
    
    private init() { }
    
    static func decrypt(cipherText: Data, keyTag: String?, algorithm: SecKeyAlgorithm) -> String? {
        guard let tag = keyTag else { return nil }
        guard let privateKey = SecKey.loadFromKeychain(tag: tag) else {
            /// no private key
            return nil
        }
        /// check if the private key can decrypt
        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else {
//            print("Algorithm \(algorithm) NOT Supported")
            return nil
        }
        
        var error: Unmanaged<CFError>?
        
        /// check if the text size is compatible with the key size
        guard cipherText.count == SecKeyGetBlockSize(privateKey) else {
            return nil
        }
        
        /// perform decrypt, the return is Data
        guard let clearTextData = SecKeyCreateDecryptedData(privateKey,
                                                            algorithm,
                                                            cipherText as CFData,
                                                            &error) as Data? else {
            return nil
        }
        
        guard let clearText = String(data: clearTextData, encoding: .utf8) else { return nil }
        return clearText
    }
    
    private static func encrypt(_ textToEncrypt: String, keyName: String, algorithm: SecKeyAlgorithm) -> Data? {
        guard let tag = GlobalConfig.shared.publicKeychainTag else { return nil }
        guard let publicKey = SecKey.loadFromKeychain(tag: tag) else {
            /// no public key
            return nil
        }
        /// check if the private key can decrypt
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
//            print("Algorithm \(algorithm) NOT Supported")
            return nil
        }
        
        var error: Unmanaged<CFError>?
        /// encrypt using public key
        let textToEncryptData = textToEncrypt.data(using: .utf8)!
        guard let cipherText = SecKeyCreateEncryptedData(publicKey,
                                                         algorithm,
                                                         textToEncryptData as CFData,
                                                         &error) as Data? else {
            return nil
        }
        return cipherText
    }
}
