//
//  VerifyPinViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 04.04.2023.
//

import Foundation
import UIKit

protocol VerifyPinService {
    func verifyPin(pin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)
}

class VerifyPinViewModel {
    private let displayAttributes: NIDisplayAttributes?
    private let formType: NIPinFormType
    private let service: VerifyPinService
    
    init(displayAttributes: NIDisplayAttributes?, formType: NIPinFormType, service: VerifyPinService) {
        self.displayAttributes = displayAttributes
        self.formType = formType
        self.service = service
    }
    
    func verifyPin(_ pin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> ()) {
        service.verifyPin(pin: pin) { success, error, callback in
            completion(success, error, callback)
        }
    }
}

// MARK: - Helpers/Utils
extension VerifyPinViewModel {
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
    
    func font(for label: UIElement.PinFormLabel) -> UIFont {
        displayAttributes?.fonts.font(for: label) ?? label.defaultFont
    }
    
    var theme: NITheme { /// default is light
        return displayAttributes?.theme ?? .light
    }
}
