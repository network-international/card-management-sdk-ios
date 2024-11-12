//
//  KeyboardButton.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 11.10.2022.
//

import UIKit

class KeyboardButton: UIButton {
    
    private var isColored = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isColored {
            isColored = true
            self.setTitleColor(color, for: .normal)
            self.tintColor = color
        }
    }
    
    private var color: UIColor {
        UIColor.init { (trait) -> UIColor in
            return trait.userInterfaceStyle == .dark ? (UIColor.darkerGrayDark ?? .label) : (UIColor.darkerGrayLight ?? .label)
        }
    }    
}
