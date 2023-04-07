//
//  VerifyPinViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 04.04.2023.
//

import Foundation
import UIKit

class VerifyPinViewModel {
    var input: NIInput
    var formType: NIPinFormType
    
    init(input: NIInput, formType: NIPinFormType) {
        self.input = input
        self.formType = formType
    }
    
    func verifyPin(_ pin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> ()) {
        NICardManagementAPI.verifyPin(pin: pin, input: input) { success, error, callback in
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
    
    func font(for label: NILabels) -> UIFont? {
        input.displayAttributes?.font(for: label)
    }
    
    var theme: NITheme { /// default is light
        return input.displayAttributes?.theme ?? .light
    }
    
}
