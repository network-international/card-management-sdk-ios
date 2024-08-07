//
//  SetPinViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 11.10.2022.
//

import Foundation
import UIKit

protocol SetPinService {
    func setPin(pin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)
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
    
    func setPin(_ pin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> ()) {
        service.setPin(pin: pin) { success, error, callback in
            completion(success, error, callback)
        }
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
    
    func font(for label: UIElement.PinFormLabel) -> UIFont {
        displayAttributes?.fonts.font(for: label) ?? label.defaultFont
    }
    
    var theme: NITheme { /// default is light
        return displayAttributes?.theme ?? .light
    }
    
}
