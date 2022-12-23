//
//  KeyboardButton.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 11.10.2022.
//

import UIKit

class KeyboardButton: UIButton {
    
    private var theme: NITheme?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 13.0, *) { } else {
            updateThemeIfNeeded()
        }
        
    }
    
    // MARK: -
    func setTheme(_ theme: NITheme) {
        self.theme = theme
    }
    
    // MARK: - Private
    private func updateThemeIfNeeded() { /// called only if device has iOS 12
        guard let theme = theme else { return }
        switch theme {
        case .light:
            self.setTitleColor(UIColor.darkerGrayLight, for: .normal)
            self.tintColor = UIColor.darkerGrayLight
        case .dark:
            self.setTitleColor(UIColor.darkerGrayDark, for: .normal)
            self.tintColor = UIColor.darkerGrayDark
        }
    }
    
}
