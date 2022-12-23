//
//  NILanguage.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 25.10.2022.
//

import Foundation

@objc public enum NILanguage: Int {
    case english
    case arabic
    
    var name: String {
        switch self {
        case .english:
            return "en"
        case .arabic:
            return "ar"
        }
    }
}
