//
//  UIColor+Utils.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 04.11.2022.
//

import UIKit

extension UIColor {
    public static let niAlwaysWhite = UIColor(named: "AlwaysWhite", in: Bundle.sdkBundle, compatibleWith: .none)!
    static let darkerGray = UIColor(named: "DarkerGray", in: Bundle.sdkBundle, compatibleWith: .none)!
    static let backgroundColor = UIColor(named: "BackgroundColor", in: Bundle.sdkBundle, compatibleWith: .none)
    
    // to be used on iOS 12.0
    static var darkerGrayLight: UIColor? {
        UIColor(hex: "#262626ff")
    }
    
    static var darkerGrayDark: UIColor? {
        UIColor(hex: "#F2F2F2FF")
    }
    
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
    
}
