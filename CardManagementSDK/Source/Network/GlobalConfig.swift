//
//  GlobalConfig.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 10.10.2022.
//

import Foundation

class GlobalConfig {
    
    static let shared = GlobalConfig()
    
    static let NIErrorDomain        = "net.networkinternational.CardManagementSDK"
    static let NIErrorKey           = "NICardManagementSDKMessage"
    static let NIErrorDebugKey      = "NICardManagementSDKDebugMessage"
    
    static let NIUniqueReferenceCodeLength = 12
    static let NIChannelId = "sdk"
    
    
    static let NIRSAAlgorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1
    
    // Language
    var language: NILanguage? = nil
    
}
