//
//  GlobalConfig.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 10.10.2022.
//

import Foundation

class GlobalConfig {
    
    static let shared = GlobalConfig()
    
    
    static let NIRSAAlgorithm: SecKeyAlgorithm = .rsaEncryptionPKCS1
    
    // Language
    var language: NILanguage? = nil
    
}
