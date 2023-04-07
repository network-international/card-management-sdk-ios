//
//  NICardManagementAPI.swift
//  CardManagementSDK
//
//  Created by Paula Radu on 04.10.2022.
//

import Foundation
import UIKit

@objc public class NICardManagementAPI: NSObject {
    
    /// Singleton instance: internal use
    static let shared = NICardManagementAPI()
    
    // MARK: - Form Factories Interface
    @objc public static func displayCardDetailsForm(input: NIInput, viewController: UIViewController, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(error: NISDKErrors.NAV_ERROR)){}
        }
        setupDisplayAttributes(input.displayAttributes)
        FormCoordinator(navigationController: viewController, route: .cardDetails(input: input), completion: completion).start()
    }
    
    @objc public static func setPinForm(input: NIInput, viewController: UIViewController, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        setupDisplayAttributes(input.displayAttributes)
        setPinForm(input: input, type: .dynamic, viewController: viewController, completion: completion)
    }
    
    @objc public static func setPinForm(input: NIInput, type: NIPinFormType, viewController: UIViewController, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(error: NISDKErrors.NAV_ERROR)){}
        }
        setupDisplayAttributes(input.displayAttributes)
        FormCoordinator(navigationController: viewController, route: .setPin(input: input, type: type), completion: completion).start()
    }
    
    @objc public static func verifyPinForm(input: NIInput, viewController: UIViewController, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        setupDisplayAttributes(input.displayAttributes)
        verifyPinForm(input: input, type: .dynamic, viewController: viewController, completion: completion)
    }
    
    @objc public static func verifyPinForm(input: NIInput, type: NIPinFormType, viewController: UIViewController, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(error: NISDKErrors.NAV_ERROR)){}
        }
        setupDisplayAttributes(input.displayAttributes)
        FormCoordinator(navigationController: viewController, route: .verifyPin(input: input, type: type), completion: completion).start()
    }
    
    @objc public static func changePinForm(input: NIInput, viewController: UIViewController, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        setupDisplayAttributes(input.displayAttributes)
        changePinForm(input: input, type: .dynamic, viewController: viewController, completion: completion)
    }
    
    @objc public static func changePinForm(input: NIInput, type: NIPinFormType, viewController: UIViewController, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(error: NISDKErrors.NAV_ERROR)){}
        }
        setupDisplayAttributes(input.displayAttributes)
        FormCoordinator(navigationController: viewController, route: .changePin(input: input, type: type), completion: completion).start()
    }
    
    // MARK: - Programatic Interface
    @objc public static func getCardDetails(input: NIInput, completion: @escaping (NICardDetailsResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        retrieveCardDetails(input: input, completion: completion)
    }
    
    @objc public static func setPin(pin: String, input: NIInput, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        shared.setPin(pin, input: input, completion: completion)
    }
    
    @objc public static func verifyPin(pin: String, input: NIInput, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        shared.verifyPin(pin, input: input, completion: completion)
    }
    
    @objc public static func changePin(oldPin: String, newPin: String, input: NIInput, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        shared.changePin(oldPin: oldPin, newPin: newPin, input: input, completion: completion)
    }
    
    
    // MARK: - Private
    private static func retrieveCardDetails(input: NIInput, completion: @escaping (NICardDetailsResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        NIMobileAPI.shared.retrieveCardDetails(input: input) { response, error in
            if let error = error {
                completion(nil, error){}
            }
            if let response = response {
                let result = NICardDetailsResponse(clearPan: response.cardNumber, maskedPan: response.maskedPan, expiry: response.expiryDate, clearCVV2: response.cvv2, cardholderName: response.holderName)
                completion(result, nil){}
            }
        }
    }
    
    private func setPin(_ pin: String, input: NIInput, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        PinManager().setPin(pin, input: input) { response, error in
            if let error = error {
                completion(nil, error){}
            } else if response != nil {
                let result = NISuccessResponse(message: "Pin set successfully!")
                completion(result, nil){}
            }
        }
    }
    
    private func verifyPin(_ pin: String, input: NIInput, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        PinManager().verifyPin(pin, input: input) { response, error in
            if let error = error {
                completion(nil, error){}
            } else if response != nil {
                let result = NISuccessResponse(message: "Pin is correct!")
                completion(result, nil){}
            }
        }
    }
    
    private func changePin(oldPin: String, newPin: String, input: NIInput, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        PinManager().changePin(oldPin: oldPin, newPin: newPin, input: input) { response, error in
            if let error = error {
                completion(nil, error){}
            } else if response != nil {
                let result = NISuccessResponse(message: "Pin changed successfully!")
                completion(result, nil){}
            }
        }
    }
    
    private static func setLanguage(_ language: NILanguage?) {
        GlobalConfig.shared.language = language
    }
    
    private static func setupDisplayAttributes(_ attributes: NIDisplayAttributes?) {
        setLanguage(attributes?.language)
        
        UIFont.registerDefaultFonts()
    }
    
}
