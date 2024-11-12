//
//  NIFontLabelPair.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 02.11.2022.
//

import UIKit

/// Enum of all labels in the UI forms
public enum UIElement {
    public enum CardDetails: CaseIterable {
        case cardNumber
        case expiry
        case cvv
        case cardHolder
        
        public var defaultLabelFont: UIFont {
            switch self {
            case .cardNumber: return UIFont.make(name: "NotoSansOriya", size: 10)
            case .expiry: return UIFont.make(name: "NotoSansOriya", size: 10)
            case .cvv: return UIFont.make(name: "NotoSansOriya", size: 10)
            case .cardHolder: return UIFont.make(name: "NotoSansOriya-Bold", size: 14)
            }
        }
        public var defaultValueFont: UIFont {
            switch self {
            case .cardNumber: return UIFont.make(name: "NotoSansOriya-Bold", size: 16)
            case .expiry: return UIFont.make(name: "NotoSansOriya-Bold", size: 14)
            case .cvv: return UIFont.make(name: "NotoSansOriya-Bold", size: 14)
            case .cardHolder: return UIFont.make(name: "NotoSansOriya", size: 10)
            }
        }
        public var defaultLabelText: String {
            switch self {
            case .cardNumber: return "CARD NUMBER"
            case .expiry: return "VALID THRU"
            case .cvv: return "CVV"
            case .cardHolder: return "NAME"
            }
        }
        public func defaultAttributedText(color: UIColor) -> NSAttributedString {
            NSAttributedString(
                string: defaultLabelText,
                attributes: [.font : defaultLabelFont, .foregroundColor: color]
            )
        }
    }
    
    public enum PinFormLabel: CaseIterable {
        /// Set PIN
        case setPinDescription
        
        /// Verify PIN
        case verifyPinDescription
        
        /// Change PIN
        case changePinDescription
        
        /// View PIN
        case viewPinCountDownDescription
        case pinDigit
        
        public var defaultFont: UIFont {
            switch self {
            case .setPinDescription, .verifyPinDescription, .changePinDescription:
                return UIFont.make(name: "NotoSansOriya", size: 18)
                
            case .pinDigit: return UIFont.make(name: "NotoSansOriya-Bold", size: 20)
            case .viewPinCountDownDescription: return UIFont.make(name: "NotoSansOriya", size: 12)
            }
        }
//        internal var defaultLabelText: String {
//            switch self {
//            case .setPinDescription:
//            case .verifyPinDescription: return "Please enter your card PIN for verification"
//            case .changePinDescription:
//                return UIFont.make(name: "NotoSansOriya", size: 18)
//                
//            case .pinDigit: return UIFont.make(name: "NotoSansOriya-Bold", size: 20)
//            case .viewPinCountDownDescription: return UIFont.make(name: "NotoSansOriya", size: 12)
//            }
//        }
    }
}

public enum NISDKStrings: String {
    case card_details_title = "Card details";
    case verify_pin_title = "Verify PIN";
    case change_pin_title = "Change PIN";
    case set_pin_title = "Set PIN";
    
    case verify_pin_description = "Please enter your card PIN for verification"
    
    case set_pin_description_enter_pin = "Please enter the desired PIN for your card";
    case set_pin_description_re_enter_pin = "Please re-enter the desired card PIN";
    case set_pin_description_pin_not_match = "PIN does not match.\nPlease re-enter the card PIN";

    case change_pin_description_enter_current_pin = "Please enter your current card PIN";
    case change_pin_description_enter_new_pin = "Please enter the new card PIN";
    case change_pin_description_re_enter_new_pin = "Please re-enter the new card PIN";
    case change_pin_description_pin_not_match = "PIN does not match.\nPlease re-enter the new card PIN";

    case view_pin_countdown_template = "PIN will be hidden in %@ seconds"

    case toast_message = "Copied to clipboard";
}

private extension UIFont {
    static func make(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
