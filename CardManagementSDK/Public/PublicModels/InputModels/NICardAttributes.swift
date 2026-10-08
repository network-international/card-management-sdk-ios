//
//  NICardAttributes.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 30.11.2022.
//

import Foundation
import UIKit

public class NICardAttributes {
    
    public static var zero: NICardAttributes = .init(
        labels: UIElement.CardDetails.allCases.reduce(into: [:], { partialResult, label in
            partialResult[label] = label.defaultAttributedText(color: .label)
        }),
        valueAttributes: UIElement.CardDetails.allCases.reduce(into: [:], { partialResult, label in
            partialResult[label] = [.font: label.defaultValueFont, .foregroundColor: UIColor.label]
        })
    )
    public static var niAlwaysWhite: NICardAttributes = .init(
        labels: UIElement.CardDetails.allCases.reduce(into: [:], { partialResult, label in
            partialResult[label] = label.defaultAttributedText(color: .niAlwaysWhite)
        }),
        valueAttributes: UIElement.CardDetails.allCases.reduce(into: [:], { partialResult, label in
            partialResult[label] = [.font: label.defaultValueFont, .foregroundColor: UIColor.niAlwaysWhite]
        })
    )
    
    /// if true, the card details will be hidden/masked by default; if false, the card details will be visible by default
    public var shouldBeMaskedDefault: Set<UIElement.CardDetails>
    
    /// if set, these labels will be used in the UI forms; if not set will use default labels
    public var labels: [UIElement.CardDetails: NSAttributedString]
    /// if set, these string attributes will be used in the UI forms; if not set will use default fonts and colors
    public var valueAttributes: [UIElement.CardDetails: [NSAttributedString.Key: Any]]
    
    public init(
        shouldBeMaskedDefault: Set<UIElement.CardDetails> = Set(UIElement.CardDetails.allCases), 
        labels: [UIElement.CardDetails: NSAttributedString] = [:],
        valueAttributes: [UIElement.CardDetails: [NSAttributedString.Key: Any]] = [:]
    ) {
        self.shouldBeMaskedDefault = shouldBeMaskedDefault
        self.labels = labels
        self.valueAttributes = valueAttributes
    }
}
