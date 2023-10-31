//
//  ViewPinViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 18.08.2023.
//

import Foundation
import UIKit

class ViewPinViewModel: NSObject {
    var input: NIInput
    var callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    var startTimer = false
    
    private (set) var pin: String? {
        didSet {
            self.bindCardDetailsViewModel()
        }
    }
    
    var bindCardDetailsViewModel = {}
    
    init(input: NIInput) {
        self.input = input
        super.init()
                
        NICardManagementAPI.getPin(input: input) { [weak self] success, error, callback in
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
    func font(for label: NILabels) -> UIFont? {
        input.displayAttributes?.font(for: label)
    }
    
    var theme: NITheme { /// default is light
        return input.displayAttributes?.theme ?? .light
    }
}
