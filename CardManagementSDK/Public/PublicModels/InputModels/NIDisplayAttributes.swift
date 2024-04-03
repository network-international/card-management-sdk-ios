//
//  NIDisplayAttributes.swift
//  CardManagementSDK
//
//  Created by Paula Radu on 04.10.2022.
//

import Foundation

public struct NIDisplayAttributes {
    
    public static let `default`: NIDisplayAttributes = .init()
    
    /// is always required, default is `.light`
    public let theme: NITheme
    
    /// if language is not set, the sdk will use the device language (english or arabic), other languages will default to english
    public let language: NILanguage?
    
    /// if set, these fonts will be used in the UI forms; if not set will use default fonts
    public let fonts: [NIFontLabelPair]?
    
    /// if set, the card details will take into account the attributes passed into this variable; if not set, will take the default values
    public let cardAttributes: NICardAttributes
    
    public init(
        theme: NITheme = .light,
        language: NILanguage? = nil,
        fonts: [NIFontLabelPair]? = nil,
        cardAttributes: NICardAttributes = .default
    ) {
        self.theme = theme
        self.language = language
        self.fonts = fonts
        self.cardAttributes = cardAttributes
    }
    
}
