//
//  NIDisplayAttributes+Utils.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 02.11.2022.
//

import UIKit

private enum DefaultFonts {
    case cardNumberLabel
    case cardNumberValueLabel
    case cardNameLabel
    case cardNameTagLabel
    case cardExpiryLabel
    case cardCvvLabel
    case cardExpiryValueLabel
    case cardCvvValueLabel
    case description
    
    private var fontName: String {
        if #available(iOS 13.0, *) { // "NotoSansOriya" font is available form ios 13.0 and above
            switch self {
            case .cardNumberLabel: return "NotoSansOriya"
            case .cardNumberValueLabel: return "NotoSansOriya-Bold"     //"OCRA"
            case .cardNameLabel: return "NotoSansOriya-Bold"            //"OCRA"
            case .cardExpiryLabel: return "NotoSansOriya"
            case .cardCvvLabel: return "NotoSansOriya"
            case .cardExpiryValueLabel: return "NotoSansOriya-Bold"     //"OCRA"
            case .cardCvvValueLabel: return "NotoSansOriya-Bold"        //"OCRA"
            case .description: return "NotoSansOriya"
            case .cardNameTagLabel: return "NotoSansOriya"
            }
        } else {
            switch self {
            case .cardNumberLabel: return "Helvetica"
            case .cardNumberValueLabel: return "OCRA"
            case .cardNameLabel: return "OCRA"
            case .cardExpiryLabel: return "Helvetica"
            case .cardCvvLabel: return "Helvetica"
            case .cardExpiryValueLabel: return "OCRA"
            case .cardCvvValueLabel: return "OCRA"
            case .description: return "Helvetica"
            case .cardNameTagLabel: return "Helvetica"
            }
        }
    }
    
    private var fontSize: CGFloat {
        switch self {
        case .cardNumberLabel: return 10.0
        case .cardNumberValueLabel: return 16.0
        case .cardNameLabel: return 14.0
        case .cardExpiryLabel: return 10.0
        case .cardCvvLabel: return 10.0
        case .cardExpiryValueLabel: return 14.0
        case .cardCvvValueLabel: return 14.0
        case .description: return 18.0
        case .cardNameTagLabel: return 10.0
        }
    }
    
    var font: UIFont {
        return UIFont(name: self.fontName, size: self.fontSize)!
    }
}

extension NIDisplayAttributes {
    
    func font(for label: NILabels) -> UIFont {
        guard let pairs = fonts, let pair: NIFontLabelPair = pairs.first(where: {$0.label == label}) else {
            switch label {
            case .cardNumberLabel: return DefaultFonts.cardNumberLabel.font
            case .cardNumberValueLabel: return DefaultFonts.cardNumberValueLabel.font
            case .expiryDateLabel: return DefaultFonts.cardExpiryLabel.font
            case .expiryDateValueLabel: return DefaultFonts.cardExpiryValueLabel.font
            case .cvvLabel: return DefaultFonts.cardCvvLabel.font
            case .cvvValueLabel: return DefaultFonts.cardCvvValueLabel.font
            case .cardholderNameLabel: return DefaultFonts.cardNameLabel.font
            case .setPinDescriptionLabel: return DefaultFonts.description.font
            case .changePinDescriptionLabel: return DefaultFonts.description.font
            case .cardholderNameTagLabel: return DefaultFonts.cardNameTagLabel.font
            }
        }
        return pair.font
    }
    
}
