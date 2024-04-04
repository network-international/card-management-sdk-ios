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
    public var shouldBeMaskedDefault: Set<UIElement.CardDetails.Value>
    
    /// if set, this image will be used as background for the card details view; if not set, it will use default image from sdk
    public var backgroundImage: UIImage?
    
    /// if set, the card details labels will be positioned accordingly
    public var textPositioning: NICardDetailsTextPositioning?
    
    /// if set, these colors will be used in the UI forms; if not set will use default colors
    public var colors: [UIElementColor]
    
    /// if set, these labels will be used in the UI forms; if not set will use default labels
    public var labels: [UIElement.CardDetails.Label: String]
    
    public init(shouldBeMaskedDefault: Set<UIElement.CardDetails.Value> = Set(UIElement.CardDetails.Value.allCases), backgroundImage: UIImage? = nil, textPositioning: NICardDetailsTextPositioning? = nil, colors: [UIElementColor] = [], labels: [UIElement.CardDetails.Label: String] = [:]) {
        self.shouldBeMaskedDefault = shouldBeMaskedDefault
        self.backgroundImage = backgroundImage
        self.textPositioning = textPositioning
        self.colors = colors
        self.labels = labels
    }
    
}
