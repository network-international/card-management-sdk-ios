//
//  NICardManagementAPI+Legacy.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 27.02.2024.
//

import UIKit

extension NICardManagementAPI {
    @available(*, deprecated, message: "Consider to use updated syntax")
    public func displayCardDetailsForm(viewController: UIViewController, displayAttributes: NIDisplayAttributes?, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        self.displayCardDetailsForm(viewController: viewController, displayAttributes: displayAttributes) { errorResp in
            if let errorResp = errorResp {
                completion(nil, errorResp){}
            } else {
                completion(NISuccessResponse(message: "Card details retrieved with success!"), nil){}
            }
        }
    }
    @available(*, deprecated, message: "Consider to use updated syntax")
    public func setPinForm(type: NIPinFormType, viewController: UIViewController, displayAttributes: NIDisplayAttributes?, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        self.setPinForm(type: type, viewController: viewController, displayAttributes: displayAttributes) { errorResp in
            if let errorResp = errorResp {
                completion(nil, errorResp){}
            } else {
                completion(NISuccessResponse(message: "Pin set successfully!"), nil){}
            }
        }
    }
    @available(*, deprecated, message: "Consider to use updated syntax")
    public func verifyPinForm(type: NIPinFormType, viewController: UIViewController, displayAttributes: NIDisplayAttributes?, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        self.verifyPinForm(type: type, viewController: viewController, displayAttributes: displayAttributes) { errorResp in
            if let errorResp = errorResp {
                completion(nil, errorResp){}
            } else {
                completion(NISuccessResponse(message: "Pin is correct!"), nil){}
            }
        }
    }
    @available(*, deprecated, message: "Consider to use updated syntax")
    public func changePinForm(type: NIPinFormType, viewController: UIViewController, displayAttributes: NIDisplayAttributes?, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        self.changePinForm(type: type, viewController: viewController, displayAttributes: displayAttributes) { errorResp in
            if let errorResp = errorResp {
                completion(nil, errorResp){}
            } else {
                completion(NISuccessResponse(message: "Pin changed successfully!"), nil){}
            }
        }
    }
    @available(*, deprecated, message: "Consider to use updated syntax")
    public func getCardDetails(completion: @escaping (NICardDetailsResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        Task {
            do {
                let result = try await self.getCardDetails()
                await MainActor.run {
                    completion(NICardDetailsResponse(result: result), nil) {}
                }
            } catch {
                await MainActor.run {
                    completion(nil, error.toLegacyResponse) {}
                }
            }
        }
    }
    @available(*, deprecated, message: "Consider to use updated syntax")
    public func setPin(pin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        Task {
            do {
                try await self.setPin(pin: pin)
                await MainActor.run {
                    completion(NISuccessResponse(message: "Pin set successfully!"), nil) {}
                }
            } catch {
                await MainActor.run {
                    completion(nil, error.toLegacyResponse) {}
                }
            }
        }
    }
    @available(*, deprecated, message: "Consider to use updated syntax")
    public func verifyPin(pin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        Task {
            do {
                try await self.verifyPin(pin: pin)
                await MainActor.run {
                    completion(NISuccessResponse(message: "Pin is correct!"), nil) {}
                }
            } catch {
                await MainActor.run {
                    completion(nil, error.toLegacyResponse) {}
                }
            }
        }
    }
    @available(*, deprecated, message: "Consider to use updated syntax")
    public func changePin(oldPin: String, newPin: String, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        Task {
            do {
                try await self.changePin(oldPin: oldPin, newPin: newPin)
                await MainActor.run {
                    completion(NISuccessResponse(message: "Pin changed successfully!"), nil) {}
                }
            } catch {
                await MainActor.run {
                    completion(nil, error.toLegacyResponse) {}
                }
            }
        }
    }
    @available(*, deprecated, message: "Consider to use updated syntax")
    public func getPin(completion: @escaping (String?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        Task {
            do {
                let result = try await self.getPin()
                await MainActor.run {
                    completion(result, nil) {}
                }
            } catch {
                await MainActor.run {
                    completion(nil, error.toLegacyResponse) {}
                }
            }
        }
    }
}

extension NICardManagementAPI {
    @available(*, deprecated, message: "Consider to use updated syntax")
    public class NICardDetailsResponse {
        public let clearPan: String?
        public let maskedPan: String?
        public let expiry: String?
        public let clearCVV2: String?
        public let cardholderName: String?
        
        init(result: NICardDetails) {
            clearPan = result.clearPan
            maskedPan = result.maskedPan
            expiry = result.expiry
            clearCVV2 = result.clearCVV2
            cardholderName = result.cardholderName
        }
    }
}

private extension Error {
    var toLegacyResponse: NIErrorResponse {
        NIErrorResponse(error: self as? NISDKError ?? NISDKError.networkError(self))
    }
}
