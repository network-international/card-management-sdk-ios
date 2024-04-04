//
//  Localizable.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 24.10.2022.
//

import Foundation


protocol NILocalizable {
    /// forced localized for the Global set language, use app localisation as a fallback
    var localized: String { get }
}

extension String: NILocalizable {

    var localized: String {
        GlobalConfig.shared.language.flatMap { localized(for: $0.name) }
        ?? localized(for: "en")
        ?? deviceLocalized
    }
    
    private var deviceLocalized: String {
        return NSLocalizedString(self, bundle: Bundle.main, comment: "")
    }
    
    private func localized(for language: String) -> String? {
        guard
            let path = Bundle(for: NICardManagementAPI.self)
                .path(forResource: language, ofType: "lproj"),
            let languageBundle = Bundle(path: path)
        else { return nil }
            
        let result = languageBundle.localizedString(forKey: self, value: self, table: nil)
        if result == self { // key not found
            return nil
        }
        return result
    }
}
