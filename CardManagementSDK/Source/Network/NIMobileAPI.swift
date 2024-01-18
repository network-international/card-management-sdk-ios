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
    
    private var rsaKeysProvider: () -> RSAKeyx509?
    private let logger: NICardManagementLogger?
    
    
    required init(
        rootUrl: String,
        cardIdentifierId: String,
        cardIdentifierType: String,
        bankCode: String,
        tokenFetchable: NICardManagementTokenFetchable,
        logger: NICardManagementLogger?
    ) {
        self.tokenFetchable = tokenFetchable
        self.cardIdentifierId = cardIdentifierId
        self.cardIdentifierType = cardIdentifierType
        self.bankCode = bankCode
        self.rootUrl = rootUrl
        self.logger = logger
        rsaKeysProvider = {
            RSA.generatePublicKeyx509() // regenerate on each keys request
        }
    }
    
    func retrieveCardDetails(completion: @escaping (CardDetailsResponse?, NIErrorResponse?) -> Void) {
        
        guard let publicKey = rsaKeysProvider() else {
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        
        let cardParams = CardDetailsParams(publicKey: publicKey.value)
        let requestBuilder: (NIConnectionProperties, RequestLogger) -> Request = { [cardParams, cardIdentifierId, cardIdentifierType, bankCode] connectionProperties, requestLogger in
            Request(.cardDetails(
                cardParams: cardParams,
                identifier: cardIdentifierId,
                type: cardIdentifierType,
                bankCode: bankCode,
                connection: connectionProperties
            ), logger: requestLogger)
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
            
            if let cardDetails = CardDetailsResponse(json: data, privateKeychainTag: publicKey.privateKeychainTag) {
                completion(cardDetails, error)
            } else {
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
            
        }
    }
    
    func cardLookup(completion: @escaping (CardLookupResponse?, NIErrorResponse?) -> Void) {
        
        guard let publicKey = rsaKeysProvider() else {
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        let params = CardLookupParams(
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            publicKey: publicKey.value
        )
        let requestBuilder: (NIConnectionProperties, RequestLogger) -> Request = { [params, bankCode] connectionProperties, requestLogger in
            Request(
                .cardsLookup(lookupParams: params, bankCode: bankCode, connection: connectionProperties),
                logger: requestLogger
            )
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
            
            if let res = CardLookupResponse(json: data, privateKeychainTag: publicKey.privateKeychainTag) {
                completion(res, error)
            } else {
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
        }
    }
    
    func retrievePinCertificate(completion: @escaping (PinCertificateResponse?, NIErrorResponse?) -> Void) {
        let requestBuilder: (NIConnectionProperties, RequestLogger) -> Request = { [bankCode] connectionProperties, requestLogger in
            Request(.pinCertificate(bankCode: bankCode, connection: connectionProperties), logger: requestLogger)
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
        
        guard let publicKey = rsaKeysProvider() else {
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        
        let params = ViewPinParams(
            publicKey: publicKey.value,
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType
        )
        let requestBuilder: (NIConnectionProperties, RequestLogger) -> Request = { [params, bankCode] connectionProperties, requestLogger in
            Request(.viewPin(
                params: params,
                bankCode: bankCode,
                connection: connectionProperties
            ), logger: requestLogger)
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
            
            
            if let resp = ViewPinResponse(json: data, privateKeychainTag: publicKey.privateKeychainTag) {
                completion(resp, error)
            } else {
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
            
        }
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
        let requestBuilder: (NIConnectionProperties, RequestLogger) -> Request = { [params, bankCode] connectionProperties, requestLogger in
            Request(.setPin(
                params: params,
                bankCode: bankCode,
                connection: connectionProperties
            ), logger: requestLogger)
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
        let requestBuilder: (NIConnectionProperties, RequestLogger) -> Request = { [params, bankCode] connectionProperties, requestLogger in
            Request(.verifyPin(
                params: params,
                bankCode: bankCode,
                connection: connectionProperties
            ), logger: requestLogger)
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
        let requestBuilder: (NIConnectionProperties, RequestLogger) -> Request = { [params, bankCode] connectionProperties, requestLogger in
            Request(.changePin(
                params: params,
                bankCode: bankCode,
                connection: connectionProperties
            ), logger: requestLogger)
        }
        sendRequest(builder: requestBuilder, completion: completion)
    }
}

extension NIMobileAPI {
    func sendRequest(retryAndRefreshToken: Bool = false, builder: @escaping (NIConnectionProperties, RequestLogger) -> Request, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        if retryAndRefreshToken { tokenFetchable.clearToken() }
        // retain self explicitry
        tokenFetchable.fetchToken { [self] result in
            switch result {
            case let .success(token):
                let request = builder(.init(rootUrl: self.rootUrl, token: token.value), RequestLoggerAdapter(logger: self.logger))
                request.sendAsync { response, error in
                    // if it is first attempt and we got 401 (auth error) - retry
                    if let error = error, error.errorCode == "401", !retryAndRefreshToken {
                        self.sendRequest(retryAndRefreshToken: true, builder: builder, completion: completion)
                        return
                    }
                    self.logger?.logNICardManagementMessage("### used token: \(token.value)")
                    guard let response = response else {
                        // clear old token if no response or error
                        self.tokenFetchable.clearToken()
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

struct RequestLoggerAdapter: RequestLogger {
    let logger: NICardManagementLogger?
    
    // MARK: - RequestLogger
    
    func logRequestStarted(_ request: URLRequest) {
        logger?.logNICardManagementMessage(
            "### request: \(request)"
            + "headers: \(request.allHTTPHeaderFields ?? [:])"
            + "httpBody: \(String(describing: request.httpBody.flatMap({ String(data: $0, encoding: .utf8) })))"
        )
    }
    
    func logRequestCompleted(_ request: URLRequest, response: URLResponse?, data: Data?, error: Error?) {
        logger?.logNICardManagementMessage(
            "### response: \(String(describing: response))\n"
            + "error: \(String(describing: error))\n"
            + "data: \(String(describing: data.flatMap({ String(data: $0, encoding: .utf8) })))"
        )
    }
}
