//
//  NIMobileAPI.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation


/// Contains request creators for NI Mobile API.

class NIMobileAPI {
    
    private let tokenFetchable: NICardManagementTokenFetchable
    private let rootUrl: String
    private let cardIdentifierId: String
    private let cardIdentifierType: String
    private let bankCode: String
    
    required init(
        rootUrl: String,
        cardIdentifierId: String,
        cardIdentifierType: String,
        bankCode: String,
        tokenFetchable: NICardManagementTokenFetchable
    ) {
        self.tokenFetchable = tokenFetchable
        self.cardIdentifierId = cardIdentifierId
        self.cardIdentifierType = cardIdentifierType
        self.bankCode = bankCode
        self.rootUrl = rootUrl
    }
    
    func retrieveCardDetails(completion: @escaping (CardDetailsResponse?, NIErrorResponse?) -> Void) {
        
        guard let publicKey = retrievePublicKey() else {
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        
        let cardParams = CardDetailsParams(publicKey: publicKey)
        let requestBuilder: (NIConnectionProperties) -> Request = { [cardParams, cardIdentifierId, cardIdentifierType, bankCode] connectionProperties in
            Request(.cardDetails(
                cardParams: cardParams,
                identifier: cardIdentifierId,
                type: cardIdentifierType,
                bankCode: bankCode,
                connection: connectionProperties
            ))
        }
        sendRequest(builder: requestBuilder) { response, error in
            
            guard let response = response else {
                if error != nil {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = response.data else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            
            if let cardDetails = CardDetailsResponse().parse(json: data) {
                completion(cardDetails, error)
            } else {
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
            
        }
    }
    
    func cardLookup(completion: @escaping (CardLookupResponse?, NIErrorResponse?) -> Void) {
        
        guard let publicKey = retrievePublicKey() else {
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        let params = CardLookupParams(
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            publicKey: publicKey
        )
        let requestBuilder: (NIConnectionProperties) -> Request = { [params, bankCode] connectionProperties in
            Request(.cardsLookup(lookupParams: params, bankCode: bankCode, connection: connectionProperties))
        }
        sendRequest(builder: requestBuilder) { response, error in
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            guard let data = response.data else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            
            if let res = CardLookupResponse().parse(json: data) {
                completion(res, error)
            } else {
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
        }
    }
    
    func retrievePinCertificate(completion: @escaping (PinCertificateResponse?, NIErrorResponse?) -> Void) {
        let requestBuilder: (NIConnectionProperties) -> Request = { [bankCode] connectionProperties in
            Request(.pinCertificate(bankCode: bankCode, connection: connectionProperties))
        }
        sendRequest(builder: requestBuilder) { response, error in
            
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            guard let data = response.data else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            
            if let res = PinCertificateResponse().parse(json: data) {
                completion(res, error)
            } else {
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
            
        }
    }
    
    func retrievePin(completion: @escaping (ViewPinResponse?, NIErrorResponse?) -> Void) {
        
        guard let publicKey = retrievePublicKey() else {
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        
        let params = ViewPinParams(
            publicKey: publicKey,
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType
        )
        let requestBuilder: (NIConnectionProperties) -> Request = { [params, bankCode] connectionProperties in
            Request(.viewPin(
                params: params,
                bankCode: bankCode,
                connection: connectionProperties
            ))
        }
        sendRequest(builder: requestBuilder) { response, error in
            
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            guard let data = response.data else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            
            if let pin = ViewPinResponse().parse(json: data) {
                completion(pin, error)
            } else {
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
            
        }
    }
    
    // MARK: - Private Utils
    private func retrievePublicKey() -> String? {
        return RSA.generatePublicKeyx509()
    }
    
    func setPin(_ encryption: PinEncryption, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        
        guard let encryptedPin = encryption.encryptedPinBlock else {
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }
        
        let params = PinParams(
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            encryptedPin: encryptedPin,
            encryptionMethod: encryption.method
        )
        let requestBuilder: (NIConnectionProperties) -> Request = { [params, bankCode] connectionProperties in
            Request(.setPin(
                params: params,
                bankCode: bankCode,
                connection: connectionProperties
            ))
        }
        sendRequest(builder: requestBuilder, completion: completion)
    }
    
    func verifyPin(_ encryption: PinEncryption, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        
        guard let encryptedPin = encryption.encryptedPinBlock else {
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }
        
        let params = PinParams(
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            encryptedPin: encryptedPin,
            encryptionMethod: encryption.method
        )
        let requestBuilder: (NIConnectionProperties) -> Request = { [params, bankCode] connectionProperties in
            Request(.verifyPin(
                params: params,
                bankCode: bankCode,
                connection: connectionProperties
            ))
        }
        sendRequest(builder: requestBuilder, completion: completion)
    }
    
    func changePin(_ encryption: (PinEncryption, PinEncryption), completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        
        guard let encryptedOldPin = encryption.0.encryptedPinBlock, let encryptedPin = encryption.1.encryptedPinBlock else {
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }
        let params = ChangePinParams(
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            encryptedOldPin: encryptedOldPin,
            encryptedNewPin: encryptedPin,
            encryptionMethod: encryption.0.method
        )
        let requestBuilder: (NIConnectionProperties) -> Request = { [params, bankCode] connectionProperties in
            Request(.changePin(
                params: params,
                bankCode: bankCode,
                connection: connectionProperties
            ))
        }
        sendRequest(builder: requestBuilder, completion: completion)
    }
}

extension NIMobileAPI {
    func sendRequest(retryAndRefreshToken: Bool = false, builder: @escaping (NIConnectionProperties) -> Request, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        if retryAndRefreshToken { tokenFetchable.clearToken() }
        // retain self explicitry
        tokenFetchable.fetchToken { [self] result in
            switch result {
            case let .success(token):
                let request = builder(.init(rootUrl: self.rootUrl, token: token.value))
                request.sendAsync { response, error in
                    // if it is first attempt and we got 401 (auth error) - retry
                    if let error = error, error.errorCode == "401", !retryAndRefreshToken {
                        self.sendRequest(retryAndRefreshToken: true, builder: builder, completion: completion)
                        return
                    }
                    guard let response = response else {
                        if error != nil {
                            completion(nil, error)
                        }
                        return
                    }
                    completion(response, error)
                }
            case let .failure(tokenError):
                let errorRespose = NIErrorResponse(error: NISDKErrors.TOKEN_ERROR)
                if case let .networkError(error) = tokenError {
                    errorRespose.errorCode = (error as NSError).code.description
                }
                // if we got token error, there are no need to retry request
                completion(nil, errorRespose)
            }
        }
    }
}

// MARK: - PinManager
extension NIMobileAPI {
    /// get card details for the card number and expiry
    private func getClearPan(completion: @escaping (String?, NIErrorResponse?) -> Void) {
        cardLookup { response, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(response?.cardNumber, error)
            }
        }
    }
    
    /// get pin certificate used for pin block encryption
    private func getPinCertificate(completion: @escaping (String?, NIErrorResponse?) -> Void) {
        retrievePinCertificate { response, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(response?.certificate, error)
            }
        }
    }
    
    func setPin(_ pin: String, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        /// 1. get clear pan
        // retain `self` by capture list
        getClearPan { [self] clearPan, error in
            guard let clearPan = clearPan else {
                completion(nil, error)
                return
            }
            /// 2. get pin certificate
            self.getPinCertificate { [self] certificate, error in
                guard let certificate = certificate else {
                    completion(nil, error)
                    return
                }
                /// 3. create and encrypt pin block
                let pinEncryption = PinEncryption(pin: pin, pan: clearPan, certificate: certificate)
                /// 4. set pin
                self.setPin(pinEncryption) { response, error in
                    if let error = error {
                        completion(nil, error)
                    } else if response != nil {
                        completion(response, nil)
                    }
                }
            }
        }
    }
    
    func verifyPin(_ pin: String, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        /// 1. get clear pan
        // retain `self` by capture list
        getClearPan { [self] clearPan, error in
            guard let clearPan = clearPan else {
                completion(nil, error)
                return
            }
            /// 2. get pin certificate
            self.getPinCertificate { [self] certificate, error in
                guard let certificate = certificate else {
                    completion(nil, error)
                    return
                }
                /// 3. create and encrypt pin block
                let pinEncryption = PinEncryption(pin: pin, pan: clearPan, certificate: certificate)
                /// 4. set pin
                self.verifyPin(pinEncryption) { response, error in
                    if let error = error {
                        completion(nil, error)
                    } else if response != nil {
                        completion(response, nil)
                    }
                }
            }
        }
    }
    
    func changePin(oldPin: String, newPin: String, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        /// 1. get clear pan
        // retain `self` by capture list
        getClearPan { [self] clearPan, error  in
            guard let clearPan = clearPan else {
                completion(nil, error)
                return
            }
            /// 2. get pin certificate
            self.getPinCertificate { [self] certificate, error in
                guard let certificate = certificate else {
                    completion(nil, error)
                    return
                }
                /// 3. create and encrypt old pin block
                let oldPinEncryption = PinEncryption(pin: oldPin, pan: clearPan, certificate: certificate)
                /// 4. create and encrypt new pin block
                let newPinEncryption = PinEncryption(pin: newPin, pan: clearPan, certificate: certificate)
                /// 4. set pin
                self.changePin((oldPinEncryption, newPinEncryption)) { response, error in
                    if let error = error {
                        completion(nil, error)
                    } else if response != nil {
                        completion(response, nil)
                    }
                }
            }
        }
    }
}
