//
//  NIMobileAPI.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation


/// Contains request creators for NI Mobile API.
/// Can propagate NISDKError

class NIMobileAPI {
    
    private let tokenFetchable: NICardManagementTokenFetchable
    private let rootUrl: String
    private let cardIdentifierId: String
    private let cardIdentifierType: String
    private let bankCode: String
    
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
        
        OpenAPIClientAPI.basePath = rootUrl
    }
    
    func retrieveCardDetails() async throws -> NICardDetailsClearResponse {
        let rsaInfo = try getRSAKeys()
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NICardDetailsClearResponse = { [self] token in
            let body = CardDetailsSecuredRequest(publicKey: rsaInfo.cert)
            let response = try await CardsAPI.securedCardDetails(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, cardIdentifierId: cardIdentifierId, body: body, cardIdentifierType: cardIdentifierType)
            let niresp = try NICardDetailsClearResponse(secured: response, privateKey: rsaInfo.privateKey)
            return niresp
        }
        return try await wrapRequest(requestBuilder: requestBuilder)
    }
    
    func cardLookup() async throws -> NICardLookupResponse {
        let rsaInfo = try getRSAKeys()
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NICardLookupResponse = { [self] token in
            let body = CardLookupRequest(cardIdentifierType: cardIdentifierType, cardIdentifierId: cardIdentifierId, publicKey: rsaInfo.cert)
            let response = try await CardsAPI.cardLookup(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, body: body)
            // cardIdentifierType != clear pan ==> encryptedCardIdentifier: response.cardIdentifierId
            let niresp = try NICardLookupResponse(encryptedCardIdentifier: response.cardIdentifierId, privateKey: rsaInfo.privateKey)
            return niresp
        }
        return try await wrapRequest(requestBuilder: requestBuilder)
    }
    
    func retrievePinCertificate() async throws -> NIPinCertificateResponse {
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NIPinCertificateResponse = { [self] token in
            let response = try await SecurityAPI.getPINCertificate(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId)
            let niresp = NIPinCertificateResponse(certificate: response.certificate)
            return niresp
        }
        return try await wrapRequest(requestBuilder: requestBuilder)
    }
    
    func retrievePin() async throws -> NIViewPinResponse {
        let rsaInfo = try getRSAKeys()
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> NIViewPinResponse = { [self] token in
            let body = PINViewRequest(cardIdentifierType: cardIdentifierType, cardIdentifierId: cardIdentifierId, publicKey: rsaInfo.cert)
            let response = try await SecurityAPI.viewPIN(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, body: body)
            let niresp = try NIViewPinResponse(encryptedPin: response.encryptedPin, privateKey: rsaInfo.privateKey)
            return niresp
        }
        return try await wrapRequest(requestBuilder: requestBuilder)
    }
    
    
    func setPin(pin: String, pan: String, certificate: String) async throws {
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> Void = { [self] token in
            let pinEncryption = try PinEncryption(pin: pin, pan: pan, certificate: certificate)
            let body = PINSetRequest(cardIdentifierId: cardIdentifierId, encryptedPin: pinEncryption.encryptedPinBlock, encryptionMethod: PINSetRequest.EncryptionMethod(rawValue: pinEncryption.method) ?? .asymmetricEnc)
            try await SecurityAPI.setPIN(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, body: body)
        }
        try await wrapRequest(requestBuilder: requestBuilder)
    }
    
    func verifyPin(pin: String, pan: String, certificate: String) async throws {
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> Void = { [self] token in
            let pinEncryption = try PinEncryption(pin: pin, pan: pan, certificate: certificate)
            let body = PINVerificationRequest(cardIdentifierType: cardIdentifierType, cardIdentifierId: cardIdentifierId, encryptedPin: pinEncryption.encryptedPinBlock, encryptionMethod: PINVerificationRequest.EncryptionMethod(rawValue: pinEncryption.method) ?? .asymmetricEnc)
            try await SecurityAPI.verifyPIN(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, body: body)
        }
        try await wrapRequest(requestBuilder: requestBuilder)
    }
    
    func changePin(oldPin: String, newPin: String, pan: String, certificate: String) async throws {
        // capture self explicitly
        let requestBuilder: (_ token: NIAccessToken) async throws -> Void = { [self] token in
            let oldPinEncryption = try PinEncryption(pin: oldPin, pan: pan, certificate: certificate)
            let newPinEncryption = try PinEncryption(pin: newPin, pan: pan, certificate: certificate)
            let body = PINChangeRequest(cardIdentifierId: cardIdentifierType, encryptedOldPin: oldPinEncryption.encryptedPinBlock, encryptedNewPin: newPinEncryption.encryptedPinBlock, encryptionMethod: PINChangeRequest.EncryptionMethod(rawValue: newPinEncryption.method) ?? .asymmetricEnc)
            try await SecurityAPI.changePIN(authorization: token.value, uniqueReferenceCode: uniqueReferenceCode, financialId: bankCode, channelId: channelId, body: body)
        }
        try await wrapRequest(requestBuilder: requestBuilder)
    }
}

// MARK: - PinManager
extension NIMobileAPI {
    func setPin(_ pin: String) async throws {
        /// get clear pan
        let pan = try await getClearPan()
        /// get pin certificate
        let cert = try await getPinCertificate()
        /// set pin
        try await setPin(pin: pin, pan: pan, certificate: cert)
    }
    
    func verifyPin(_ pin: String) async throws {
        /// get clear pan
        let pan = try await getClearPan()
        /// get pin certificate
        let cert = try await getPinCertificate()
        /// verify pin
        try await verifyPin(pin: pin, pan: pan, certificate: cert)
    }
    
    func changePin(oldPin: String, newPin: String) async throws {
        /// get clear pan
        let pan = try await getClearPan()
        /// get pin certificate
        let cert = try await getPinCertificate()
        /// change pin
        try await changePin(oldPin: oldPin, newPin: newPin, pan: pan, certificate: cert)
    }
}

private extension NIMobileAPI {
    var uniqueReferenceCode: String {
        APIEndpoint.uniqueReferenceCode
    }
    var channelId: String {
        APIEndpoint.channelId
    }
    
    func getRSAKeys() throws -> RSAKeyx509 {
        do {
            // regenerate on each keys request
            let tag = "com.\(Bundle.sdkBundle.bundleIdentifier ?? "NISDK").keys.\(bankCode)".data(using: .utf8)!
            return try RSA.generateRSAKeyx509(tag: tag, isPermanent: false)
        } catch {
            logger?.logNICardManagementMessage("RSA error \(error)")
            throw NISDKError.rsaKeyError(error as? KeychainError)
        }
    }
    
    /// get card details for the card number and expiry
    func getClearPan() async throws -> String {
        try await cardLookup().cardNumber
    }
    
    /// get pin certificate used for pin block encryption
    func getPinCertificate() async throws -> String {
        guard let cert = try await retrievePinCertificate().certificate, !cert.isEmpty else {
            throw RSADecryptError.emptyData
        }
        return cert
    }
    
    /// Convert error to NISDKError
    func wrapRequest<T: Any>(requestBuilder: (_ token: NIAccessToken) async throws -> T) async throws -> T {
        do {
            let token = try await tokenFetchable.fetchToken()
            let result = try await requestBuilder(token)
            return result
        } catch {
            // clear old token if no response or error
            self.tokenFetchable.clearToken()
            
            if case ErrorResponse.error(let status, let data, let urlResp, let respError) = error {
                throw NISDKError.responseError(status, data, urlResp, respError)
            } else if error is RSADecryptError {
                throw NISDKError.cryptoError(error as? RSADecryptError)
            } else if let tokenError = error as? TokenError {
                throw NISDKError.tokenError(tokenError)
            } else {
                throw NISDKError.networkError(error)
            }
        }
    }
}

struct RequestLoggerAdapter {
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
