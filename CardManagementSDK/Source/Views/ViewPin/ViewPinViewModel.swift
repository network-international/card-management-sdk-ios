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

public class ViewPinViewModel {
    public struct Config {
        public let countDownTemplate: String
        public let digitFont: UIFont
        public var colorInput: UIColor?
        public var timer: Double
        
        public init(countDownTemplate: String, digitFont: UIFont, colorInput: UIColor? = nil, timer: Double) {
            self.countDownTemplate = countDownTemplate
            self.digitFont = digitFont
            self.colorInput = colorInput
            self.timer = timer
        }
        
        public static let `default` = Config(
            countDownTemplate: NISDKStrings.view_pin_countdown_template.rawValue, 
            digitFont: UIElement.PinFormLabel.pinDigit.defaultFont,
            colorInput: UIColor.label,
            timer: 0
        )
    }
    
    var callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    var startTimer = false
    
    let config: Config
    private let service: ViewPinService
    
    private(set) var pin: String? {
        didSet {
            self.bindCardDetailsViewModel()
        }
    }
    
    var bindCardDetailsViewModel = {}
    
    public init(config: Config, service: ViewPinService) {
        self.config = config
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
