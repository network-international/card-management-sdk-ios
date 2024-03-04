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

extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            /// xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutSetup()
        return contentView
    }
    
    private func layoutSetup() {
        superview?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        superview?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        superview?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        superview?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}
