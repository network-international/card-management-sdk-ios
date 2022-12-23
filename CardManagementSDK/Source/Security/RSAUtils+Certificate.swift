//
//  RSAUtils+Certificate.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 28.10.2022.
//

import Foundation
import Security


import Foundation

extension RSAUtils {
    
    /// Used to encrypt PIN BLOCK with the public key from the x509 Certificate received from NI Moble API
    static func encrypt(string: String, certificate: String?) -> String? {
        guard let certificate = certificate else { return nil }
        
        // Convert the certificate string to Data
        guard let data = Data(base64Encoded: certificate) else {
            return nil
        }
        
        // Create SecCertificate object using certificate data
        guard let cer = SecCertificateCreateWithData(nil, data as CFData) else { 
            return nil
        }
        
        var trust: SecTrust?
        
        // Retrieve a SecTrust using the SecCertificate object. Provide X509 as policy
        let status = SecTrustCreateWithCertificates(cer, SecPolicyCreateBasicX509(), &trust)
        
        // Check if the trust generation is success
        guard status == errSecSuccess else { return nil }
        
        // Retrieve the SecKey using the trust hence generated
        guard let secKey = SecTrustCopyPublicKey(trust!) else { return nil }
        
        let encryptedString = encrypt(string, publicKey: secKey, algorithm: GlobalConfig.NIRSAAlgorithm)
        return encryptedString
    }
    
    private static func encrypt(_ textToEncrypt: String, publicKey: SecKey, algorithm: SecKeyAlgorithm) -> String? {
        var error: Unmanaged<CFError>?
        /// encrypt using public key
        let textToEncryptData = textToEncrypt.hexaData
        guard let cipherTextData = SecKeyCreateEncryptedData(publicKey,
                                                             algorithm,
                                                             textToEncryptData as CFData,
                                                             &error) as Data? else {
            return nil
        }
        
        return cipherTextData.hexString()
    }
    
}
