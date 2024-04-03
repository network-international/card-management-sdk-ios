//
//  NICardAttributes.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 30.11.2022.
//

import Foundation
import UIKit

public struct NICardAttributes {
    
    public static let `default`: NICardAttributes = .init()
    
    /// if true, the card details will be hidden/masked by default; if false, the card details will be visible by default
    public let shouldHide: Bool
    
    /// if set, this image will be used as background for the card details view; if not set, it will use default image from sdk
    public let backgroundImage: UIImage?
    
    /// if set, the card details labels will be positioned accordingly
    public let textPositioning: TextPositioning?
    
    /// Color for text labels, default is `.alwaysWhite`
    public let elementsColor: UIColor
    
    public init(shouldHide: Bool = true, backgroundImage: UIImage? = nil, textPositioning: TextPositioning? = nil, elementsColor: UIColor = .niAlwaysWhite) {
        self.shouldHide = shouldHide
        self.backgroundImage = backgroundImage
        self.textPositioning = textPositioning
        self.elementsColor = elementsColor
    }
}

extension NICardAttributes {
    public struct TextPositioning {
        let leftAlignment: Double
        let cardNumberGroupTopAlignment: Double
        let dateCvvGroupTopAlignment: Double
        let cardHolderNameGroupTopAlignment: Double
        
        public init(leftAlignment: Double, cardNumberGroupTopAlignment: Double, dateCvvGroupTopAlignment: Double, cardHolderNameGroupTopAlignment: Double) {
            self.leftAlignment = leftAlignment
            self.cardNumberGroupTopAlignment = cardNumberGroupTopAlignment
            self.dateCvvGroupTopAlignment = dateCvvGroupTopAlignment
            self.cardHolderNameGroupTopAlignment = cardHolderNameGroupTopAlignment
        }
    }
}
