//
//  NIFontLabelPair.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 02.11.2022.
//

import UIKit

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
    
    /// Cahnge PIN
    case changePinDescriptionLabel
}
