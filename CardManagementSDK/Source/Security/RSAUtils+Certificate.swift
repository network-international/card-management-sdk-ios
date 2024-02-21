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
    static func encrypt(string: String, certificate: String) throws -> String {
        guard
            // Convert the certificate string to Data
            let data = Data(base64Encoded: certificate),
            // Create SecCertificate object using certificate data
            let cer = SecCertificateCreateWithData(nil, data as CFData)
        else {
            throw RSADecryptError.emptyData
        }
        
        var trust: SecTrust?
        // Retrieve a SecTrust using the SecCertificate object. Provide X509 as policy
        let status = SecTrustCreateWithCertificates(cer, SecPolicyCreateBasicX509(), &trust)
        
        // Check if the trust generation is success
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        // Retrieve the SecKey using the trust hence generated
        guard let secKey = SecTrustCopyKey(trust!) else {
            // this can happen if the public key algorithm is not supported
            throw KeychainError.publicKeyNotAvailable
        }
        
        var error: Unmanaged<CFError>?
        /// encrypt using public key
        let textToEncryptData = string.hexaData
        guard let cipherTextData = SecKeyCreateEncryptedData(secKey,
                                                             GlobalConfig.NIRSAAlgorithm,
                                                             textToEncryptData as CFData,
                                                             &error) as Data? else {
            throw RSADecryptError.decryptError(error!.takeRetainedValue() as Error)
        }
        return cipherTextData.hexString()
    }
}
