//
//  RSA.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 18.10.2022.
//

import Foundation

struct RSAKeyx509 {
    let cert: String
    let privateKey: SecKey
}

class RSA {
    
    private init() { }
    
    static func generateRSAKeyx509(tag: Data, isPermanent: Bool) throws -> RSAKeyx509 {
        
        let now = Date()
        let certInfo = try SecCertificate.create(
            ofSize: 4096,
            subjectCommonName: "NICardManagementSDK_iOS",
            validFrom: now.addingTimeInterval(-24 * 3600),
            // consider self.validFrom.addingTimeInterval(365*24*3600)
            validTo: now.addingTimeInterval(24 * 3600),
            tag: tag,
            isPermanent: isPermanent
        )
        
        
        /*
        if use keychain and identity approach {
            let pubKey = try certInfo.cert.publicKey()
            let privKey = certInfo.privKey // SecKey.loadFromKeychain(tag: privtag)
            let identity = SecIdentity.findIdentity(forPrivateKey:privKey, publicKey:pubKey)
            if let cert = identity.certificate {
                let certData = SecCertificateCopyData(cert)
                
                let privateKeychainTag = identity.privateKey?.keychainTag
                let publicKeychainTag = cert.publicKey?.keychainTag
                
                return RSAKeyx509(cert: certBase64, privateKey: privKey)
            }
        }
         */
        
        let certData = SecCertificateCopyData(certInfo.cert)
        let certBase64 = (certData as Data).base64EncodedString()
        // alternativelly only public key could be used
        // instead of it's wrapper
        // let pubKeyData = SecKeyCopyExternalRepresentation(cert.publicKey, &error)
        return RSAKeyx509(cert: certBase64, privateKey: certInfo.privKey)
    }
    
}


