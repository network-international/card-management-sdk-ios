//
//  DotView.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 11.10.2022.
//

import UIKit

class DotView: UIView {
    
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func shouldFillDot(_ fill: Bool) {
        if fill {
            self.layer.backgroundColor = UIColor.lightGray.cgColor
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            self.layer.backgroundColor = UIColor.clear.cgColor
            self.backgroundColor = UIColor.clear
            self.layer.borderWidth = 1.5
            self.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
}
