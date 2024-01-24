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
    
    private var rsaKeysProvider: () throws -> RSAKeyx509
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
            // regenerate on each keys request
            let tag = "com.\(Bundle.sdkBundle.bundleIdentifier ?? "NISDK").keys.\(bankCode)".data(using: .utf8)!
            return try RSA.generateRSAKeyx509(tag: tag, isPermanent: false)
        }
    }
    
    func retrieveCardDetails(completion: @escaping (CardDetailsResponse?, NIErrorResponse?) -> Void) {
        let rsaInfo: RSAKeyx509
        do {
            rsaInfo = try rsaKeysProvider()
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }

        
        let cardParams = CardDetailsParams(publicKey: rsaInfo.cert)
        let requestBuilder: (NIConnectionProperties, RequestLogger) -> Request = { [cardParams, cardIdentifierId, cardIdentifierType, bankCode] connectionProperties, requestLogger in
            Request(.cardDetails(
                cardParams: cardParams,
                identifier: cardIdentifierId,
                type: cardIdentifierType,
                bankCode: bankCode,
                connection: connectionProperties
            ), logger: requestLogger)
        }
        sendRequest(builder: requestBuilder) { [privKey = rsaInfo.privateKey] response, error in
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
            do {
                let cardDetails = try CardDetailsResponse(json: data, privateKey: privKey)
                completion(cardDetails, error)
            } catch {
                // logger?.logNICardManagementMessage("RSA error \(error)")
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
        }
    }
    
    func cardLookup(completion: @escaping (CardLookupResponse?, NIErrorResponse?) -> Void) {
        
        let rsaInfo: RSAKeyx509
        do {
            rsaInfo = try rsaKeysProvider()
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        
        let params = CardLookupParams(
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            publicKey: rsaInfo.cert
        )
        let requestBuilder: (NIConnectionProperties, RequestLogger) -> Request = { [params, bankCode] connectionProperties, requestLogger in
            Request(
                .cardsLookup(lookupParams: params, bankCode: bankCode, connection: connectionProperties),
                logger: requestLogger
            )
        }
        sendRequest(builder: requestBuilder) { [privKey = rsaInfo.privateKey] response, error in
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            guard let data = response.data else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            do {
                let res = try CardLookupResponse(json: data, privateKey: privKey)
                completion(res, error)
            } catch {
                // logger?.logNICardManagementMessage("RSA error \(error)")
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
            do {
                let res = try PinCertificateResponse(json: data)
                completion(res, error)
            } catch {
                // logger?.logNICardManagementMessage("RSA error \(error)")
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
        }
    }
    
    func retrievePin(completion: @escaping (ViewPinResponse?, NIErrorResponse?) -> Void) {
        let rsaInfo: RSAKeyx509
        do {
            rsaInfo = try rsaKeysProvider()
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        
        let params = ViewPinParams(
            publicKey: rsaInfo.cert,
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
        sendRequest(builder: requestBuilder) { [privKey = rsaInfo.privateKey] response, error in
            
            guard let response = response else {
                completion(nil, error)
                return
            }
            
            guard let data = response.data else {
                completion(nil, NIErrorResponse(error: NISDKErrors.NETWORK_ERROR))
                return
            }
            do {
                let res = try ViewPinResponse(json: data, privateKey: privKey)
                completion(res, error)
            } catch {
                // logger?.logNICardManagementMessage("RSA error \(error)")
                completion(nil, NIErrorResponse(error: NISDKErrors.PARSING_ERROR))
            }
        }
    }
    
    
    func setPin(pin: String, pan: String, certificate: String, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        let pinEncryption: PinEncryption
        do {
            pinEncryption = try PinEncryption(pin: pin, pan: pan, certificate: certificate)
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }
        
        let params = PinParams(
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            encryptedPin: pinEncryption.encryptedPinBlock,
            encryptionMethod: pinEncryption.method
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
    
    func verifyPin(pin: String, pan: String, certificate: String, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        let pinEncryption: PinEncryption
        do {
            pinEncryption = try PinEncryption(pin: pin, pan: pan, certificate: certificate)
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }
        
        let params = PinParams(
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            encryptedPin: pinEncryption.encryptedPinBlock,
            encryptionMethod: pinEncryption.method
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
    
    func changePin(oldPin: String, newPin: String, pan: String, certificate: String, completion: @escaping (Response?, NIErrorResponse?) -> Void) {
        let oldPinEncryption: PinEncryption
        let newPinEncryption: PinEncryption
        do {
            oldPinEncryption = try PinEncryption(pin: oldPin, pan: pan, certificate: certificate)
            newPinEncryption = try PinEncryption(pin: newPin, pan: pan, certificate: certificate)
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }

        let params = ChangePinParams(
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            encryptedOldPin: oldPinEncryption.encryptedPinBlock,
            encryptedNewPin: newPinEncryption.encryptedPinBlock,
            encryptionMethod: newPinEncryption.method
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
                /// 4. set pin
                self.setPin(pin: pin, pan: clearPan, certificate: certificate) { response, error in
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
                /// 4. set pin
                self.verifyPin(pin: pin, pan: clearPan, certificate: certificate) { response, error in
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
                /// 3. set pin
                self.changePin(oldPin: oldPin, newPin: newPin, pan: clearPan, certificate: certificate) { response, error in
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
        let headers = request.allHTTPHeaderFields?.keys.joined(separator: ", ") ?? ""
        let bodyFields = request.httpBody
            .flatMap({
                try? JSONSerialization.jsonObject(with: $0, options: []) as? [String : Any]
            })
            .flatMap({ "[" + $0.keys.joined(separator: ", ") + "]" })
        let refCode = request.allHTTPHeaderFields?["Unique-Reference-Code"] ?? "-"
        let authorization: String
        let authorizationParts = request.allHTTPHeaderFields?["Authorization"]?.split(separator: " ")
        if let authorizationParts = authorizationParts,
            authorizationParts.count == 2,
            authorizationParts[0] == "Bearer"
        {
            let token = authorizationParts[1]
            let masked = token.count > 8
            ? (token.prefix(4) + "****" + token.suffix(4))
            : "****"
            authorization = "\(authorizationParts[0]) \(masked)"
        } else {
            authorization = "unknown"
        }
        logger?.logNICardManagementMessage(
            "\n### request: \(request.url?.absoluteString ?? "")"
            + "\nheaders (keys): [\(headers)]"
            + "\nReference code: \(refCode)"
            + "\nAuthorization: \(authorization)"
            + "\nbody fields: \(bodyFields ?? "")"
            + "\n"
        )
    }
    
    func logRequestCompleted(_ request: URLRequest, response: URLResponse?, data: Data?, error: Error?) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        let responseData = statusCode == 200
        ? data
            .flatMap({
                (try? JSONSerialization.jsonObject(with: $0, options: []) as? [String : Any])
            })
            .flatMap({ "[" + $0.keys.joined(separator: ", ") + "]" })
        : data.flatMap({ String(data: $0, encoding: .utf8) })
        logger?.logNICardManagementMessage(
            "\n### response: \(response?.url?.absoluteString ?? "")"
            + "\nstatus code: \(statusCode?.description ?? "")"
            + "\nerror: \(String(describing: error))"
            + "\nresponse fields: \(responseData ?? "")"
            + "\n"
        )
    }
}
