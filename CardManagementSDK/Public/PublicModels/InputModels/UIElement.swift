//
//  NIFontLabelPair.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 02.11.2022.
//

import UIKit

public protocol ColorAssignable: Equatable {}
public protocol FontAssignable: Equatable {
    var defaultFont: UIFont { get }
}

public struct UIElementFont {
    public let element: any FontAssignable
    public let font: UIFont
    public init(element: any FontAssignable, font: UIFont) {
        self.element = element
        self.font = font
    }
}
public struct UIElementColor {
    public let element: any ColorAssignable
    public let color: UIColor
    public init(element: any ColorAssignable, color: UIColor) {
        self.element = element
        self.color = color
    }
}

/// Enum of all labels in the UI forms
public enum UIElement {
    public enum CardDetails {
        public enum Label: CaseIterable, FontAssignable, ColorAssignable {
            case cardNumber
            case expiry
            case cvv
            case cardHolder
        }
        public enum Value: CaseIterable, FontAssignable, ColorAssignable {
            case cardNumber
            case expiry
            case cvv
            case cardHolder
        }
    }
    
    public enum PinFormLabel: CaseIterable, FontAssignable {
        /// Set PIN
        case setPinDescription
        
        /// Verify PIN
        case verifyPinDescription
        
        /// Change PIN
        case changePinDescription
        
        /// View PIN
        case viewPinCountDownDescription
        case pinDigit
    }
}

public extension UIElement.CardDetails.Label {
    var defaultFont: UIFont {
        switch self {
        case .cardNumber: return UIFont.make(name: "NotoSansOriya", size: 10)
        case .expiry: return UIFont.make(name: "NotoSansOriya", size: 10)
        case .cvv: return UIFont.make(name: "NotoSansOriya", size: 10)
        case .cardHolder: return UIFont.make(name: "NotoSansOriya-Bold", size: 14)
        }
    }
}
public extension UIElement.CardDetails.Value {
    var defaultFont: UIFont {
        switch self {
        case .cardNumber: return UIFont.make(name: "NotoSansOriya-Bold", size: 16)
        case .expiry: return UIFont.make(name: "NotoSansOriya-Bold", size: 14)
        case .cvv: return UIFont.make(name: "NotoSansOriya-Bold", size: 14)
        case .cardHolder: return UIFont.make(name: "NotoSansOriya", size: 10)
        }
    }
}
public extension UIElement.PinFormLabel {
    var defaultFont: UIFont {
        switch self {
        case .setPinDescription, .verifyPinDescription, .changePinDescription:
            return UIFont.make(name: "NotoSansOriya", size: 18)
            
        case .pinDigit: return UIFont.make(name: "NotoSansOriya-Bold", size: 20)
        case .viewPinCountDownDescription: return UIFont.make(name: "NotoSansOriya", size: 12)
        }
    }
}

internal extension Collection where Element == UIElementFont {
    func font<T: FontAssignable>(for label: T) -> UIFont {
        self.first { wrapper in
            if let uiLabel = wrapper.element as? T {
                return uiLabel == label
            }
            return false
        }?.font ?? label.defaultFont
    }
}
internal extension Collection where Element == UIElementColor {
    func color<T: ColorAssignable>(for label: T) -> UIColor? {
        self.first { wrapper in
            if let uiLabel = wrapper.element as? T {
                return uiLabel == label
            }
            return false
        }?.color
    }
}
internal extension Optional where Wrapped == any Collection<UIElementColor> {
    func color<T: ColorAssignable>(for label: T) -> UIColor? {
        self?.color(for: label)
    }
}
internal extension Optional where Wrapped == any Collection<UIElementFont> {
    func font<T: FontAssignable>(for label: T) -> UIFont {
        self?.font(for: label) ?? label.defaultFont
    }
}

private extension UIFont {
    static func make(name: String, size: CGFloat) -> UIFont {
        guard #available(iOS 13.0, *) else {
            switch name {
            case "NotoSansOriya":
                return UIFont(name: "Helvetica", size: size)!
            case "NotoSansOriya-Bold":
                return UIFont(name: "OCRA", size: size)!
            default:
                return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
            }
        }
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
