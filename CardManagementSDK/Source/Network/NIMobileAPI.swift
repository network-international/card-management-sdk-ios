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
        
        OpenAPIClientAPI.basePath = rootUrl
    }
    
    func retrieveCardDetails(completion: @escaping (NICardDetailsResponse?, NIErrorResponse?) -> Void) {
        let rsaInfo: RSAKeyx509
        do {
            rsaInfo = try rsaKeysProvider()
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NICardDetailsResponse = { [self] token in
            let body = CardDetailsSecuredRequest(publicKey: rsaInfo.cert)
            let response = try await CardsAPI.securedCardDetails(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, cardIdentifierId: cardIdentifierId, body: body, cardIdentifierType: cardIdentifierType)
            let niresp = try NICardDetailsResponse(secured: response, privateKey: rsaInfo.privateKey)
            return niresp
        }
        Task {
            let result = await wrapRequest(requestBuilder: requestBuilder)
            completion(result.0, result.1)
        }
    }
    
    func cardLookup(completion: @escaping (NICardLookupResponse?, NIErrorResponse?) -> Void) {
        let rsaInfo: RSAKeyx509
        do {
            rsaInfo = try rsaKeysProvider()
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NICardLookupResponse = { [self] token in
            let body = CardLookupRequest(cardIdentifierType: cardIdentifierType, cardIdentifierId: cardIdentifierId, publicKey: rsaInfo.cert)
            let response = try await CardsAPI.cardLookup(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, body: body)
            // cardIdentifierType != clear pan ==> encryptedCardIdentifier: response.cardIdentifierId
            let niresp = try NICardLookupResponse(encryptedCardIdentifier: response.cardIdentifierId, privateKey: rsaInfo.privateKey)
            return niresp
        }
        Task {
            let result = await wrapRequest(requestBuilder: requestBuilder)
            completion(result.0, result.1)
        }
    }
    
    func retrievePinCertificate(completion: @escaping (NIPinCertificateResponse?, NIErrorResponse?) -> Void) {
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NIPinCertificateResponse = { [self] token in
            let response = try await SecurityAPI.getPINCertificate(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId)
            let niresp = NIPinCertificateResponse(certificate: response.certificate)
            return niresp
        }
        Task {
            let result = await wrapRequest(requestBuilder: requestBuilder)
            completion(result.0, result.1)
        }
    }
    
    func retrievePin(completion: @escaping (NIViewPinResponse?, NIErrorResponse?) -> Void) {
        let rsaInfo: RSAKeyx509
        do {
            rsaInfo = try rsaKeysProvider()
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR))
            return
        }
        
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NIViewPinResponse = { [self] token in
            let body = PINViewRequest(cardIdentifierType: cardIdentifierType, cardIdentifierId: cardIdentifierId, publicKey: rsaInfo.cert)
            let response = try await SecurityAPI.viewPIN(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, body: body)
            let niresp = try NIViewPinResponse(encryptedPin: response.encryptedPin, privateKey: rsaInfo.privateKey)
            return niresp
        }
        Task {
            let result = await wrapRequest(requestBuilder: requestBuilder)
            completion(result.0, result.1)
        }
    }
    
    
    func setPin(pin: String, pan: String, certificate: String, completion: @escaping (NIResponse?, NIErrorResponse?) -> Void) {
        let pinEncryption: PinEncryption
        do {
            pinEncryption = try PinEncryption(pin: pin, pan: pan, certificate: certificate)
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }
        
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NIResponse = { [self] token in
            let body = PINSetRequest(cardIdentifierId: cardIdentifierId, encryptedPin: pinEncryption.encryptedPinBlock, encryptionMethod: PINSetRequest.EncryptionMethod(rawValue: pinEncryption.method) ?? .asymmetricEnc)
            try await SecurityAPI.setPIN(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, body: body)
            return NIResponse(data: nil, response: nil, error: nil)
        }
        Task {
            let result = await wrapRequest(requestBuilder: requestBuilder)
            completion(result.0, result.1)
        }
    }
    
    func verifyPin(pin: String, pan: String, certificate: String, completion: @escaping (NIResponse?, NIErrorResponse?) -> Void) {
        let pinEncryption: PinEncryption
        do {
            pinEncryption = try PinEncryption(pin: pin, pan: pan, certificate: certificate)
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            completion(nil, NIErrorResponse(error: NISDKErrors.PINBLOCK_ENCRYPTION_ERROR))
            return
        }
        
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NIResponse = { [self] token in
            let body = PINVerificationRequest(cardIdentifierType: cardIdentifierType, cardIdentifierId: cardIdentifierId, encryptedPin: pinEncryption.encryptedPinBlock, encryptionMethod: PINVerificationRequest.EncryptionMethod(rawValue: pinEncryption.method) ?? .asymmetricEnc)
            try await SecurityAPI.verifyPIN(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, body: body)
            return NIResponse(data: nil, response: nil, error: nil)
        }
        Task {
            let result = await wrapRequest(requestBuilder: requestBuilder)
            completion(result.0, result.1)
        }
    }
    
    func changePin(oldPin: String, newPin: String, pan: String, certificate: String, completion: @escaping (NIResponse?, NIErrorResponse?) -> Void) {
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
        
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NIResponse = { [self] token in
            let body = PINChangeRequest(cardIdentifierId: cardIdentifierType, encryptedOldPin: oldPinEncryption.encryptedPinBlock, encryptedNewPin: newPinEncryption.encryptedPinBlock, encryptionMethod: PINChangeRequest.EncryptionMethod(rawValue: newPinEncryption.method) ?? .asymmetricEnc)
            try await SecurityAPI.changePIN(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, body: body)
            return NIResponse(data: nil, response: nil, error: nil)
        }
        Task {
            let result = await wrapRequest(requestBuilder: requestBuilder)
            completion(result.0, result.1)
        }
    }
}

extension NIMobileAPI {
    func wrapRequest<T: Any>(requestBuilder: (_ token: NIAccessToken) async throws -> T) async -> (T?, NIErrorResponse?) {
        do {
            let token = try await tokenFetchable.fetchToken()
            let result = try await requestBuilder(token)
            return (result, nil)
        } catch {
            let resultError: NIErrorResponse
            if case ErrorResponse.error(_, let data, let urlResp, let respError) = error {
                let res = NIResponse(data: data, response: urlResp, error: respError as NSError?)
                let nierror = NIErrorResponse().withResponse(response: res) ?? NIErrorResponse(error: NISDKErrors.NETWORK_ERROR)
                resultError = nierror.isError ? nierror : NIErrorResponse(error: NISDKErrors.NETWORK_ERROR)
            } else if error is RSADecryptError {
                resultError = NIErrorResponse(error: NISDKErrors.RSAKEY_ERROR)
            } else if let tokenError = error as? TokenError {
                let errorRespose = NIErrorResponse(error: NISDKErrors.TOKEN_ERROR)
                if case let .networkError(error) = tokenError {
                    errorRespose.errorCode = (error as NSError).code.description
                }
                resultError = errorRespose
            } else {
                let res = NIResponse(data: nil, response: nil, error: error as NSError?)
                resultError = NIErrorResponse().withResponse(response: res) ?? NIErrorResponse(error: NISDKErrors.NETWORK_ERROR)
            }
            // clear old token if no response or error
            self.tokenFetchable.clearToken()
            return (nil, resultError)
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
    
    func setPin(_ pin: String, completion: @escaping (NIResponse?, NIErrorResponse?) -> Void) {
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
    
    func verifyPin(_ pin: String, completion: @escaping (NIResponse?, NIErrorResponse?) -> Void) {
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
    
    func changePin(oldPin: String, newPin: String, completion: @escaping (NIResponse?, NIErrorResponse?) -> Void) {
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

private extension NIMobileAPI {
    var uniqueReferenceCode: String {
        String.randomString(length: GlobalConfig.NIUniqueReferenceCodeLength)
    }
    var channelId: String {
        GlobalConfig.NIChannelId
    }
}
