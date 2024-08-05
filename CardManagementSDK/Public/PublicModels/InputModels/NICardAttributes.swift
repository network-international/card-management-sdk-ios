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
    
    /// if set, these colors will be used in the UI forms; if not set will use default colors
    public var colors: [UIElementColor]
    
    /// if set, these labels will be used in the UI forms; if not set will use default labels
    public var labels: [UIElement.CardDetails.Label: String]
    
    public init(shouldBeMaskedDefault: Set<UIElement.CardDetails.Value> = Set(UIElement.CardDetails.Value.allCases), colors: [UIElementColor] = [], labels: [UIElement.CardDetails.Label: String] = [:]) {
        self.shouldBeMaskedDefault = shouldBeMaskedDefault
        self.colors = colors
        self.labels = labels
    }
    
}
