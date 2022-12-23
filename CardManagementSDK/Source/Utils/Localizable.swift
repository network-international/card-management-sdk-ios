//
//  Localizable.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 24.10.2022.
//

import Foundation


protocol NILocalizable {
    /// localized for device language
    var deviceLocalized: String { get }
    
    /// forced localized for the Globla set language
    var localized: String { get }
    
    /// localized for the given language
    func localized(for language: String) -> String
}

extension String: NILocalizable {
    
    var deviceLocalized: String {
        return NSLocalizedString(self, bundle: Bundle(for: NICardManagementAPI.self), comment: "")
    }
    
    var localized: String {
        if let language = GlobalConfig.shared.language {
            return localized(for: language.name)
        } else {
            return deviceLocalized
        }
    }
    
    func localized(for language: String) -> String {
        let bundle = Bundle(for: NICardManagementAPI.self)
        if let path = bundle.path(forResource: language, ofType: "lproj") {
            let languageBundle = Bundle(path: path)
            return languageBundle?.localizedString(forKey: self, value: self, table: nil) ?? ""
        }
        return "" /// Language not supported
    }
    
}
