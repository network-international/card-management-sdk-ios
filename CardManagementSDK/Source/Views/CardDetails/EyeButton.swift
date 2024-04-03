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
            let image = isSelected ? NIResource.eyeClosedImage : NIResource.eyeOpenImage
            self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
}
