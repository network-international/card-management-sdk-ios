//
//  ChangePinViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 24.10.2022.
//

import Foundation
import UIKit

protocol ChangePinService {
    func changePin(oldPin: String, newPin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)
}

public class ChangePinViewModel {
    public struct Config {
        public let enterCurrentPinText: NSAttributedString
        public let enterNewPinText: NSAttributedString
        public let reEnterNewPinText: NSAttributedString
        public let notMatchPinText: NSAttributedString
        public let titleText: String
        public let backgroundColor: UIColor?

        public static let `default` = Config(
            enterCurrentPinText: NSAttributedString(
                string: NISDKStrings.change_pin_description_enter_current_pin.rawValue,
                attributes: [.font : UIElement.PinFormLabel.changePinDescription.defaultFont, .foregroundColor: UIColor.label]
            ),
            enterNewPinText: NSAttributedString(
                string: NISDKStrings.change_pin_description_enter_new_pin.rawValue,
                attributes: [.font : UIElement.PinFormLabel.changePinDescription.defaultFont, .foregroundColor: UIColor.label]
            ),
            reEnterNewPinText: NSAttributedString(
                string: NISDKStrings.change_pin_description_re_enter_new_pin.rawValue,
                attributes: [.font : UIElement.PinFormLabel.changePinDescription.defaultFont, .foregroundColor: UIColor.label]
            ),
            notMatchPinText: NSAttributedString(
                string: NISDKStrings.change_pin_description_pin_not_match.rawValue,
                attributes: [.font : UIElement.PinFormLabel.changePinDescription.defaultFont, .foregroundColor: UIColor.label]
            ),
            titleText: NISDKStrings.change_pin_title.rawValue,
            backgroundColor: UIColor.backgroundColor
        )
        
        public init(enterCurrentPinText: NSAttributedString, enterNewPinText: NSAttributedString, reEnterNewPinText: NSAttributedString, notMatchPinText: NSAttributedString, titleText: String, backgroundColor: UIColor?) {
            self.enterCurrentPinText = enterCurrentPinText
            self.enterNewPinText = enterNewPinText
            self.reEnterNewPinText = reEnterNewPinText
            self.notMatchPinText = notMatchPinText
            self.titleText = titleText
            self.backgroundColor = backgroundColor
        }
    }
    
    let config: Config
    private let formType: NIPinFormType
    private let service: ChangePinService
    
    init(config: Config, formType: NIPinFormType, service: ChangePinService) {
        self.config = config
        self.formType = formType
        self.service = service
    }
    
    func changePin(oldPin: String, newPin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> ()) {
        service.changePin(oldPin: oldPin, newPin: newPin) { success, error, callback in
            completion(success, error, callback)
        }
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
}
