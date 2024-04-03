//
//  NIFontLabelPair.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 02.11.2022.
//

import UIKit

enum NIUIElementConfig {
    struct MaskedPartConfig {
        var maskingElement: String // "*", TODO: check maskedPan
        var attributes: [NSAttributedString.Key: Any]
        // masking offset, consider replace to range, eg NSRange(location: 17, length: 7)
        var offset: Int
    }
    case label(text: String, attributes: [NSAttributedString.Key: Any])
    case value(
        attributes: [NSAttributedString.Key: Any],
        maskedPartConfig: MaskedPartConfig?
    )
}

enum NIUICardDetailsElement {
    case cardNumber
    case cardNumberValue
    case expiryDate
    case expiryDateValue
    case cvv
    case cvvValue
    case cardholderName
    case cardholderNameTagLabel
}

struct NIUICardDetailsConfig {
    var items: [NIUICardDetailsElement: NIUIElementConfig]
    
    static let `dafault` = NIUICardDetailsConfig(items: [
        .cardNumber : .label(
            text: "card_number".localized,
            attributes: [
                .font : DefaultFonts.cardNumberLabel.font,
                .foregroundColor
            ]
        )
    ])
}

public enum NIUIElement {
    /// Card Details
    
    
    /// Set PIN
    case setPinDescriptionLabel
    
    /// Verify PIN
    case verifyPinDescriptionLabel
    
    /// Change PIN
    case changePinDescriptionLabel
    
    /// View PIN
    case viewPinCountDownDescription
    case pinDigitLabel
}


/// Object used to set a font for a label. Each label from the UI forms can be set individually
@objc public class NIFontLabelPair: NSObject {
    public var font: UIFont
    public var label: NILabels
    
    @objc public init(font: UIFont, label: NILabels) {
        self.font = font
        self.label = label
    }
}


/// Enum of all labels in the UI forms
@objc public enum NILabels: Int {
    
    /// Card Details
    case cardNumberLabel
    case cardNumberValueLabel
    case expiryDateLabel
    case expiryDateValueLabel
    case cvvLabel
    case cvvValueLabel
    case cardholderNameLabel
    case cardholderNameTagLabel
    
    /// Set PIN
    case setPinDescriptionLabel
    
    /// Verify PIN
    case verifyPinDescriptionLabel
    
    /// Change PIN
    case changePinDescriptionLabel
    
    /// View PIN
    case viewPinCountDownDescription
    case pinDigitLabel
}
