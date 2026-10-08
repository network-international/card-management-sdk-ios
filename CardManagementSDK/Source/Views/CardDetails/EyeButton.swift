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
            let eyeOpen = Bundle.sdkImage(named: "icon_open_eye")?.withRenderingMode(.alwaysTemplate)
            let eyeClosed = Bundle.sdkImage(named: "icon_close_eye")?.withRenderingMode(.alwaysTemplate)
            self.setImage(isSelected ? eyeClosed : eyeOpen, for: .normal)
        }
    }
}
