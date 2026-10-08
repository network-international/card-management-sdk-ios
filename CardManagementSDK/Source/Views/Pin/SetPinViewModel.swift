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

public class SetPinViewModel {
    public struct Config {
        public let enterPinText: NSAttributedString
        public let reEnterPinText: NSAttributedString
        public let notMatchPinText: NSAttributedString
        public let titleText: String
        public let backgroundColor: UIColor?

        public static let `default` = Config(
            enterPinText: NSAttributedString(
                string: NISDKStrings.set_pin_description_enter_pin.rawValue,
                attributes: [.font : UIElement.PinFormLabel.setPinDescription.defaultFont, .foregroundColor: UIColor.label]
            ),
            reEnterPinText: NSAttributedString(
                string: NISDKStrings.set_pin_description_re_enter_pin.rawValue,
                attributes: [.font : UIElement.PinFormLabel.setPinDescription.defaultFont, .foregroundColor: UIColor.label]
            ),
            notMatchPinText: NSAttributedString(
                string: NISDKStrings.set_pin_description_pin_not_match.rawValue,
                attributes: [.font : UIElement.PinFormLabel.setPinDescription.defaultFont, .foregroundColor: UIColor.label]
            ),
            titleText: NISDKStrings.set_pin_title.rawValue,
            backgroundColor: UIColor.backgroundColor
        )
        
        public init(enterPinText: NSAttributedString, reEnterPinText: NSAttributedString, notMatchPinText: NSAttributedString, titleText: String, backgroundColor: UIColor?) {
            self.enterPinText = enterPinText
            self.reEnterPinText = reEnterPinText
            self.notMatchPinText = notMatchPinText
            self.titleText = titleText
            self.backgroundColor = backgroundColor
        }
    }
    
    let config: Config
    private let formType: NIPinFormType
    private let service: SetPinService
    
    init(config: Config, formType: NIPinFormType, service: SetPinService) {
        self.config = config
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
}
