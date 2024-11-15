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

public class VerifyPinViewModel {
    
    public struct Config {
        public let descriptionAttributedText: NSAttributedString
        public let titleText: String
        public let backgroundColor: UIColor?
        
        public init(descriptionAttributedText: NSAttributedString, titleText: String, backgroundColor: UIColor?) {
            self.descriptionAttributedText = descriptionAttributedText
            self.titleText = titleText
            self.backgroundColor = backgroundColor
        }
        
        public static let `default` = Config(
            descriptionAttributedText: NSAttributedString(
                string: NISDKStrings.verify_pin_description.rawValue,
                attributes: [.font : UIElement.PinFormLabel.verifyPinDescription.defaultFont, .foregroundColor: UIColor.label]
            ),
            titleText: NISDKStrings.verify_pin_title.rawValue,
            backgroundColor: UIColor.backgroundColor
        )
    }
    
    let config: Config
    private let formType: NIPinFormType
    private let service: VerifyPinService
    
    init(config: Config, formType: NIPinFormType, service: VerifyPinService) {
        self.config = config
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
}
