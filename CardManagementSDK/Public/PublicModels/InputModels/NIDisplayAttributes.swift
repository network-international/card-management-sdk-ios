//
//  NIDisplayAttributes.swift
//  CardManagementSDK
//
//  Created by Paula Radu on 04.10.2022.
//

import Foundation

@objc public class NIDisplayAttributes: NSObject {
    
    /// is always required
    public var theme: NITheme
    
    /// if language is not set, the sdk will use the device language (english or arabic), other languages will default to english
    public var language: NILanguage?
    
    /// if set, these fonts will be used in the UI forms; if not set will use default fonts
    public var fonts: [NIFontLabelPair]?
    
    /// if set, the card details will take into account the attributes passed into this variable; if not set, will take the default values
    public var cardAttributes: NICardAttributes?
    
    @objc public init(theme: NITheme) {
        self.theme = theme
    }
    
    @objc public init(theme: NITheme, language: NILanguage) {
        self.theme = theme
        self.language = language
    }
    
    @objc public init(theme: NITheme, fonts: [NIFontLabelPair]) {
        self.theme = theme
        self.fonts = fonts
    }
    
    @objc public init(theme: NITheme, cardAttributes: NICardAttributes) {
        self.theme = theme
        self.cardAttributes = cardAttributes
    }
    
    @objc public init(theme: NITheme, language: NILanguage, cardAttributes: NICardAttributes) {
        self.theme = theme
        self.language = language
        self.cardAttributes = cardAttributes
    }
    
    @objc public init(theme: NITheme, fonts: [NIFontLabelPair], cardAttributes: NICardAttributes) {
        self.theme = theme
        self.fonts = fonts
        self.cardAttributes = cardAttributes
    }
    
    @objc public init(theme: NITheme, language: NILanguage, fonts: [NIFontLabelPair]) {
        self.theme = theme
        self.language = language
        self.fonts = fonts
    }
    
    @objc public init(theme: NITheme, language: NILanguage, fonts: [NIFontLabelPair], cardAttributes: NICardAttributes) {
        self.theme = theme
        self.language = language
        self.fonts = fonts
        self.cardAttributes = cardAttributes
    }
    
}
