//
//  NICardManagementAPI.swift
//  CardManagementSDK
//
//  Created by Paula Radu on 04.10.2022.
//

import Foundation
import UIKit

public protocol NICardManagementLogger {
    func logNICardManagementMessage(_ message: String)
}

public final class NICardManagementAPI {
    
    private let mobileApi: NIMobileAPI
    private let logger: NICardManagementLogger?
    
    public init(
        rootUrl: String,
        cardIdentifierId: String,
        cardIdentifierType: String,
        bankCode: String,
        tokenFetchable: NICardManagementTokenFetchable,
        logger: NICardManagementLogger? = nil
    ) {
        self.mobileApi = NIMobileAPI(
            rootUrl: rootUrl,
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            bankCode: bankCode,
            tokenFetchable: tokenFetchable, 
            logger: logger
        )
        self.logger = logger
        UIFont.registerDefaultFonts()
    }
    
    // MARK: - Form Factories Interface
    public func displayCardDetailsForm(
        viewController: UIViewController,
        displayAttributes: NIDisplayAttributes = .zero,
        language: NILanguage? = nil,
        cardViewBackground: UIImage?,
        cardViewTextPositioning: NICardDetailsTextPositioning?,
        completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void
    ) {
        
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(error: NISDKErrors.NAV_ERROR)){}
        }
        makeCoordinator(with: viewController, displayAttributes: displayAttributes, language: language, cardViewBackground: cardViewBackground, cardViewTextPositioning: cardViewTextPositioning)
            .coordinate(route: .cardDetails, completion: completion)
    }
    
    public func setPinForm(type: NIPinFormType, viewController: UIViewController, displayAttributes: NIDisplayAttributes = .zero, language: NILanguage?, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(error: NISDKErrors.NAV_ERROR)){}
        }
        makeCoordinator(with: viewController, displayAttributes: displayAttributes, language: language)
            .coordinate(route: .setPin(type: type), completion: completion)
    }
    
    public func verifyPinForm(type: NIPinFormType, viewController: UIViewController, displayAttributes: NIDisplayAttributes = .zero, language: NILanguage?, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(error: NISDKErrors.NAV_ERROR)){}
        }
        makeCoordinator(with: viewController, displayAttributes: displayAttributes, language: language)
            .coordinate(route: .verifyPin(type: type), completion: completion)
    }
    
    public func changePinForm(type: NIPinFormType, viewController: UIViewController, displayAttributes: NIDisplayAttributes = .zero, language: NILanguage?, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(error: NISDKErrors.NAV_ERROR)){}
        }
        makeCoordinator(with: viewController, displayAttributes: displayAttributes, language: language)
            .coordinate(route: .changePin(type: type), completion: completion)
    }
    
    // MARK: - Card UI elements presenter
    /// use it to fill any custom layout by UI elements of this presenter
    /// so the card details data is not passed in raw format
    /// after building presenter, call `presenter.showCardDetails(completion:)`
    public func buildCardDetailsPresenter(displayAttributes: NIDisplayAttributes = .zero, language: NILanguage?) -> NICardElementsPresenter {
        let presenter = NICardElementsPresenter()
        presenter.setup(language: language, displayAttributes: displayAttributes, service: self)
        return presenter
    }
    
    // MARK: - Programatic Interface
    public func getCardDetails(completion: @escaping (NICardDetailsResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        mobileApi.retrieveCardDetails { response, error in
            var resp: NICardDetailsResponse?
            if let response = response {
                resp = NICardDetailsResponse(clearPan: response.cardNumber, maskedPan: response.maskedPan, expiry: response.expiryDate, clearCVV2: response.cvv2, cardholderName: response.cardholderName)
            }
            if Thread.isMainThread {
                completion(resp, error){}
            } else {
                DispatchQueue.main.async {
                    completion(resp, error){}
                }
            }
        }
    }
    
    public func setPin(pin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        mobileApi.setPin(pin) { response, error in
            if let error = error {
                completion(nil, error){}
            } else if response != nil {
                let result = NISuccessResponse(message: "Pin set successfully!")
                completion(result, nil){}
            }
        }
    }
    
    public func verifyPin(pin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        mobileApi.verifyPin(pin) { response, error in
            if let error = error {
                completion(nil, error){}
            } else if response != nil {
                let result = NISuccessResponse(message: "Pin is correct!")
                completion(result, nil){}
            }
        }
    }
    
    public func changePin(oldPin: String, newPin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        mobileApi.changePin(oldPin: oldPin, newPin: newPin) { response, error in
            if let error = error {
                completion(nil, error){}
            } else if response != nil {
                let result = NISuccessResponse(message: "Pin changed successfully!")
                completion(result, nil){}
            }
        }
    }
    
    public func getPin(completion: @escaping (String?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        mobileApi.retrievePin { response, error in
            if let error = error {
                completion(nil, error){}
            }
            if let response = response {
                let result = response.pin
                completion(result, nil){}
            }
        }
    }
}

// MARK: - Private
private extension NICardManagementAPI {
    func makeCoordinator(
        with navigationController: UIViewController,
        displayAttributes: NIDisplayAttributes = .zero,
        language: NILanguage?,
        cardViewBackground: UIImage? = nil,
        cardViewTextPositioning: NICardDetailsTextPositioning? = nil
    ) -> FormCoordinator {
        return FormCoordinator(
            navigationController: navigationController,
            displayAttributes: displayAttributes,
            service: self,
            language: language,
            cardViewBackground: cardViewBackground,
            cardViewTextPositioning: cardViewTextPositioning
        )
    }
}

extension NICardManagementAPI: FormCoordinatorService {}
extension NICardManagementAPI: ViewPinService {}
