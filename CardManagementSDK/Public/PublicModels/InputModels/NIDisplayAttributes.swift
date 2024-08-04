//
//  NIDisplayAttributes.swift
//  CardManagementSDK
//
//  Created by Paula Radu on 04.10.2022.
//

import UIKit

public class NIDisplayAttributes {
    
    public static var zero: NIDisplayAttributes = .init()
    
    /// is always required, default is `.light`
    public var theme: NITheme
    
    /// if set, these fonts will be used in the UI forms; if not set will use default fonts
    public var fonts: [UIElementFont]
    
    /// if set, the card details will take into account the attributes passed into this variable; if not set, will take the default values
    public var cardAttributes: NICardAttributes
    
    public init(
        theme: NITheme = .light,
        fonts: [UIElementFont] = [],
        cardAttributes: NICardAttributes = .zero
    ) {
        self.theme = theme
        self.fonts = fonts
        self.cardAttributes = cardAttributes
    }
    
}
