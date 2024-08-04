//
//  LogoView.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 17.11.2023.
//

import UIKit
import NICardManagementSDK

class LogoView: UIView {
    
    private let logoImageView: UIImageView
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    required init(currentLanguage: NILanguage) {
        logoImageView = UIImageView(image: currentLanguage.logo)
        logoImageView.contentMode = .scaleAspectFit
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
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
    
    func update(with language: NILanguage) {
        logoImageView.image = language.logo
        switch language {
        case .arabic:
            leadingConstraint.priority = .defaultLow
            trailingConstraint.priority = .defaultHigh
        case .english:
            leadingConstraint.priority = .defaultHigh
            trailingConstraint.priority = .defaultLow
        }
    }
}

fileprivate extension NILanguage {
    var logo: UIImage {
        switch self {
        case .english:
            return UIImage(resource: .logoEn)
        case .arabic:
            return UIImage(resource: .logoAr)
        }
    }
}
