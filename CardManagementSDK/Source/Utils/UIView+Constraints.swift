//
//  UIView+Constraints.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 25.10.2022.
//

import UIKit

extension UIView {
    
    func alignConstraintsToView(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let margins = view.layoutMarginsGuide
        self.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        self.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
    }
}
