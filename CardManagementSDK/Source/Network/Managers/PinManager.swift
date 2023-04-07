//
//  PinManager.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 20.10.2022.
//

import Foundation

class PinManager {
    
    func setPin(_ pin: String, input: NIInput, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        /// 1. get clear pan
        getClearPan(input) { clearPan in
            guard let clearPan = clearPan else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            /// 2. get pin certificate
            self.getPinCertificate(input: input) { certificate in
                guard let certificate = certificate else {
                    completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                    return
                }
                /// 3. create and encrypt pin block
                let pinEncryption = PinEncryption(pin: pin, pan: clearPan, certificate: certificate)
                /// 4. set pin
                NIMobileAPI.shared.setPin(pinEncryption, input: input) { response, error in
                    if let error = error {
                        completion(nil, error)
                    } else if response != nil {
                        completion(response, nil)
                    }
                }
            }
        }
    }
    
    func verifyPin(_ pin: String, input: NIInput, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        /// 1. get clear pan
        getClearPan(input) { clearPan in
            guard let clearPan = clearPan else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            /// 2. get pin certificate
            self.getPinCertificate(input: input) { certificate in
                guard let certificate = certificate else {
                    completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                    return
                }
                /// 3. create and encrypt pin block
                let pinEncryption = PinEncryption(pin: pin, pan: clearPan, certificate: certificate)
                /// 4. set pin
                NIMobileAPI.shared.verifyPin(pinEncryption, input: input) { response, error in
                    if let error = error {
                        completion(nil, error)
                    } else if response != nil {
                        completion(response, nil)
                    }
                }
            }
        }
    }
    
    func changePin(oldPin: String, newPin: String, input: NIInput, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        /// 1. get clear pan
        getClearPan(input) { clearPan in
            guard let clearPan = clearPan else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            /// 2. get pin certificate
            self.getPinCertificate(input: input) { certificate in
                guard let certificate = certificate else {
                    completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR)) 
                    return
                }
                /// 3. create and encrypt old pin block
                let oldPinEncryption = PinEncryption(pin: oldPin, pan: clearPan, certificate: certificate)
                /// 4. create and encrypt new pin block
                let newPinEncryption = PinEncryption(pin: newPin, pan: clearPan, certificate: certificate)
                /// 4. set pin
                NIMobileAPI.shared.changePin((oldPinEncryption, newPinEncryption), input: input) { response, error in
                    if let error = error {
                        completion(nil, error)
                    } else if response != nil {
                        completion(response, nil)
                    }
                }
            }
        }
    }
    
    /// get card details for the card number and expiry
    private func getClearPan(_ input: NIInput, completion: @escaping (String?) -> Void) {
        NIMobileAPI.shared.cardLookup(identifier: input.cardIdentifierId, type: input.cardIdentifierType, bankCode: input.bankCode, input.connectionProperties) { response, error in
            if error != nil {
                completion(nil)
            }
            let clearPan = response?.cardNumber
            completion(clearPan)
        }
    }
    
    /// get pin certificate used for pin block encryption
    private func getPinCertificate(input: NIInput, completion: @escaping (String?) -> Void) {
        NIMobileAPI.shared.retrievePinCertificate(bankCode: input.bankCode, input.connectionProperties) { response, error in
            if error != nil {
                completion(nil)
            }
            completion(response?.certificate)
        }
    }
}
