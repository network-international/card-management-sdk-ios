//
//  RSAUtils.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 21.10.2022.
//

import Foundation

enum RSACryptoError: Error {
    case algorithmNotSupported(SecKeyAlgorithm)
    case decryptError(Error)
    case emptyData
}

class RSAUtils {
    
    private init() { }
    
    static func decrypt(cipherText: Data, privateKey: SecKey, algorithm: SecKeyAlgorithm) throws -> String {
        /// check if the private key can decrypt
        guard SecKeyIsAlgorithmSupported(privateKey, .decrypt, algorithm) else {
            throw RSACryptoError.algorithmNotSupported(algorithm)
        }
        
        var error: Unmanaged<CFError>?
        /// perform decrypt, the return is Data
        guard let clearTextData = SecKeyCreateDecryptedData(privateKey,
                                                            algorithm,
                                                            cipherText as CFData,
                                                            &error) as Data? else {
            throw RSACryptoError.decryptError(error!.takeRetainedValue() as Error)
        }
        
        guard 
            let clearText = String(data: clearTextData, encoding: .utf8)
        else { 
            throw RSACryptoError.emptyData
        }
        return clearText
    }
    // Internal
    static func encrypt(_ textToEncrypt: String, publicKey: SecKey, algorithm: SecKeyAlgorithm) throws -> Data {
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            throw RSACryptoError.algorithmNotSupported(algorithm)
        }
        
        var error: Unmanaged<CFError>?
        /// encrypt using public key
        let textToEncryptData = textToEncrypt.data(using: .utf8)!
        guard let cipherText = SecKeyCreateEncryptedData(publicKey,
                                                         algorithm,
                                                         textToEncryptData as CFData,
                                                         &error) as Data? else {
            throw RSACryptoError.decryptError(error!.takeRetainedValue() as Error)
        }
        return cipherText
    }
}
