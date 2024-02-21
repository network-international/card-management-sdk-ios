//
//  SetPinViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 11.10.2022.
//

import Foundation
import UIKit

protocol SetPinService {
    func setPin(pin: String) async throws
}

class SetPinViewModel {
    private let displayAttributes: NIDisplayAttributes?
    private let formType: NIPinFormType
    private let service: SetPinService
    
    init(displayAttributes: NIDisplayAttributes?, formType: NIPinFormType, service: SetPinService) {
        self.displayAttributes = displayAttributes
        self.formType = formType
        self.service = service
    }
    
    func setPin(_ pin: String) async throws {
        try await service.setPin(pin: pin)
    }
}

// MARK: - Helpers/Utils
extension SetPinViewModel {
    var dotsCount: Int {
        switch formType {
        case .dynamic:      return 6
        case .fourDigits:   return 4
        case .fiveDigits:   return 5
        case .sixDigits:    return 6
        }
    }
    
    var fixedLength: Bool {
        return formType != .dynamic
    }
    
    func font(for label: NILabels) -> UIFont? {
        displayAttributes?.font(for: label)
    }
    
    var theme: NITheme { /// default is light
        return displayAttributes?.theme ?? .light
    }
    
}
