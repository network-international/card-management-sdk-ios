//
//  RSA.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 18.10.2022.
//

import Foundation

class RSA {
    
    private init() { }
    
    static func generatePublicKeyx509() -> String? {
        
        let now = Date()
        guard let identity = SecIdentity.create(
            ofSize: 4096,
            subjectCommonName: "NICardManagementSDK_iOS", //"CN=PaulaR, OU=ITdepartment, O=Endava, L=Cluj, ST=Cluj, C=Romania"
            subjectEmailAddress: "paula.radu@endava.com",
            validFrom: now.addingTimeInterval(-24 * 3600),
            validTo: now.addingTimeInterval(24 * 3600)
        ) else {
            return nil
        }
        
        if let cert = identity.certificate {
            let certData = SecCertificateCopyData(cert)
            
            GlobalConfig.shared.privateKeychainTag = identity.privateKey?.keychainTag
            GlobalConfig.shared.publicKeychainTag = cert.publicKey?.keychainTag
            
            let certBase64 = (certData as Data).base64EncodedString()
            return certBase64
        }
        
        return nil
    }
    
}
