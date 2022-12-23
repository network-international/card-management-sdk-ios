//
//  EyeButton.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 27.11.2022.
//

import UIKit

class EyeButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            let eyeOpen = UIImage(named: "icon_open_eye", in: Bundle.sdkBundle, compatibleWith: .none)
            let eyeClosed = UIImage(named: "icon_close_eye", in: Bundle.sdkBundle, compatibleWith: .none)
            self.setImage(isSelected ? eyeClosed : eyeOpen, for: .normal)
        }
    }
}
