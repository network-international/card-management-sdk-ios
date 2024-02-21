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
    public func displayCardDetailsForm(viewController: UIViewController, displayAttributes: NIDisplayAttributes?, completion: @escaping (NIErrorResponse?) -> Void) {
        
        if viewController is UINavigationController {
            completion(.wrondNavigation)
        }
        makeCoordinator(with: viewController, displayAttributes: displayAttributes)
            .coordinate(route: .cardDetails, completion: completion)
    }
    
    public func setPinForm(type: NIPinFormType, viewController: UIViewController, displayAttributes: NIDisplayAttributes?, completion: @escaping (NIErrorResponse?) -> Void) {
        if viewController is UINavigationController {
            completion(.wrondNavigation)
        }
        makeCoordinator(with: viewController, displayAttributes: displayAttributes)
            .coordinate(route: .setPin(type: type), completion: completion)
    }
    
    public func verifyPinForm(type: NIPinFormType, viewController: UIViewController, displayAttributes: NIDisplayAttributes?, completion: @escaping (NIErrorResponse?) -> Void) {
        if viewController is UINavigationController {
            completion(.wrondNavigation)
        }
        makeCoordinator(with: viewController, displayAttributes: displayAttributes)
            .coordinate(route: .verifyPin(type: type), completion: completion)
    }
    
    public func changePinForm(type: NIPinFormType, viewController: UIViewController, displayAttributes: NIDisplayAttributes?, completion: @escaping (NIErrorResponse?) -> Void) {
        if viewController is UINavigationController {
            completion(.wrondNavigation)
        }
        makeCoordinator(with: viewController, displayAttributes: displayAttributes)
            .coordinate(route: .changePin(type: type), completion: completion)
    }
    
    // MARK: - Programatic Interface
    
    /// NICardDetails on success, otherwise throws NISDKError
    public func getCardDetails() async throws -> NICardDetails {
        let response = try await mobileApi.retrieveCardDetails()
        let result = NICardDetails(clearPan: response.cardNumber, maskedPan: response.maskedPan, expiry: response.expiryDate, clearCVV2: response.cvv2, cardholderName: response.cardholderName)
        return result
    }
    /// No error on success, otherwise throws NISDKError
    public func setPin(pin: String) async throws {
        try await mobileApi.setPin(pin)
    }
    /// No error on success, otherwise throws NISDKError
    public func verifyPin(pin: String) async throws {
        try await mobileApi.verifyPin(pin)
    }
    /// No error on success, otherwise throws NISDKError
    public func changePin(oldPin: String, newPin: String) async throws {
        try await mobileApi.changePin(oldPin: oldPin, newPin: newPin)
    }
    /// Pin string on success, otherwise throws NISDKError
    public func getPin() async throws -> String {
        try await mobileApi.retrievePin().pin
    }
}

// MARK: - Private
private extension NICardManagementAPI {
    func makeCoordinator(with navigationController: UIViewController, displayAttributes: NIDisplayAttributes?) -> FormCoordinator {
        GlobalConfig.shared.language = displayAttributes?.language
        return FormCoordinator(
            navigationController: navigationController,
            displayAttributes: displayAttributes,
            service: self
        )
    }
}

extension NICardManagementAPI: FormCoordinatorService {}
extension NICardManagementAPI: ViewPinService {}
