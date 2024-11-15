//
//  LogoView.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 17.11.2023.
//

import UIKit
import NICardManagementSDK

class LogoView: UIView {
    
    private var logoImageView: UIImageView
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    required init(isArabic: Bool) {
        logoImageView = UIImageView(image: Self.logo(isArabic: isArabic))
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            logoImageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.5),
            logoImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        leadingConstraint = logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        trailingConstraint = logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        leadingConstraint.priority = .defaultHigh
        trailingConstraint.priority = .defaultLow
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(isArabic: Bool) {
        logoImageView.image = Self.logo(isArabic: isArabic)
        if isArabic {
            leadingConstraint.priority = .defaultLow
            trailingConstraint.priority = .defaultHigh
        } else {
            leadingConstraint.priority = .defaultHigh
            trailingConstraint.priority = .defaultLow
        }
    }
    
    static func logo(isArabic: Bool) -> UIImage {
        isArabic ? UIImage(resource: .logoAr) : UIImage(resource: .logoEn)
    }
}

