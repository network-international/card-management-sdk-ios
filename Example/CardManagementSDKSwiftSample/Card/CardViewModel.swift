//
//  CardViewModel.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 17.11.2023.
//

import Foundation

class CardViewModel {
    let settingsProvider: SettingsProvider
    
    init(settingsProvider: SettingsProvider) {
        self.settingsProvider = settingsProvider
    }
}
