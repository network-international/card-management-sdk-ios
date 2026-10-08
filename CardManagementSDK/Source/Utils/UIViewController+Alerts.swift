//
//  UIViewController+Alerts.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 20.10.2022.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String? = nil, message: String? = nil, buttonTitle: String? = nil, buttonHandler: @escaping (Any) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let buttonTitle = buttonTitle {
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: buttonHandler))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    alert.dismiss(animated: false, completion: nil)
                }
            })
        }
    }
    
}
