//
//  ChangePinViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 24.10.2022.
//

import Foundation
import UIKit

protocol ChangePinService {
    func changePin(oldPin: String, newPin: String) async throws
}

class ChangePinViewModel {
    private let displayAttributes: NIDisplayAttributes?
    private let formType: NIPinFormType
    private let service: ChangePinService
    
    init(displayAttributes: NIDisplayAttributes?, formType: NIPinFormType, service: ChangePinService) {
        self.displayAttributes = displayAttributes
        self.formType = formType
        self.service = service
    }
    
    func changePin(oldPin: String, newPin: String) async throws {
        try await service.changePin(oldPin: oldPin, newPin: newPin)
    }
}

// MARK: - Helpers/Utils
extension ChangePinViewModel {
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
