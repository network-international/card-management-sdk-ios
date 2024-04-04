//
//  ViewPinViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 18.08.2023.
//

import Foundation
import UIKit

public protocol ViewPinService {
    func getPin(completion: @escaping (String?, NIErrorResponse?, @escaping () -> Void) -> Void)
}

class ViewPinViewModel {
    var callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    var startTimer = false
    
    private let displayAttributes: NIDisplayAttributes?
    private let service: ViewPinService
    
    private(set) var pin: String? {
        didSet {
            self.bindCardDetailsViewModel()
        }
    }
    
    var bindCardDetailsViewModel = {}
    
    init(displayAttributes: NIDisplayAttributes?, service: ViewPinService) {
        self.displayAttributes = displayAttributes
        self.service = service
        getPin()
    }
    
    func getPin() {
        service.getPin { [weak self] success, error, callback in
            guard let self = self else { return }
            
            if let response = success {
                if response != "" {
                    self.callback?(NISuccessResponse(message: "Pin retrieved with success!"), error){}
                    self.pin = response
                    self.startTimer = true
                } else {
                    self.callback?(nil, NIErrorResponse(error: .NO_DATA_ERROR)){}
                    self.pin = "----"
                    self.startTimer = false
                }
            } else {
                self.callback?(nil, error){}
                self.pin = "----"
                self.startTimer = false
            }
        }
    }
}

// MARK: - Helpers/Utils
extension ViewPinViewModel {    
    var theme: NITheme { /// default is light
        return displayAttributes?.theme ?? .light
    }
    func font(for label: UIElement.PinFormLabel) -> UIFont {
        displayAttributes?.fonts.font(for: label) ?? label.defaultFont
    }
}
