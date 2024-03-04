//
//  NICardAttributes.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 30.11.2022.
//

import Foundation
import UIKit

public class NICardAttributes {
    
    public static var zero: NICardAttributes = .init()
    
    /// if true, the card details will be hidden/masked by default; if false, the card details will be visible by default
    public var shouldHide: Bool
    
    /// if set, this image will be used as background for the card details view; if not set, it will use default image from sdk
    public var backgroundImage: UIImage?
    
    /// if set, the card details labels will be positioned accordingly
    public var textPositioning: NICardDetailsTextPositioning?
    
    /// Color for text labels, default is `.alwaysWhite`
    public var elementsColor: UIColor
    
    public init(shouldHide: Bool = true, backgroundImage: UIImage? = nil, textPositioning: NICardDetailsTextPositioning? = nil, elementsColor: UIColor = .niAlwaysWhite) {
        self.shouldHide = shouldHide
        self.backgroundImage = backgroundImage
        self.textPositioning = textPositioning
        self.elementsColor = elementsColor
    }
    
}
