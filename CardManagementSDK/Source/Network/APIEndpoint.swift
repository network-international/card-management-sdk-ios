//
//  APIEndpoint.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation


// API Endpoints enum - path, headers, parameters

enum APIEndpoint {
    case cardsLookup(lookupParams: CardLookupParams, bankCode: String, connection: NIConnectionProperties)
    case cardDetails(cardParams: CardDetailsParams, identifier: String, type: String, bankCode: String, connection: NIConnectionProperties)
    case pinCertificate(bankCode: String, connection: NIConnectionProperties)
    case setPin(params: PinParams, bankCode: String, connection: NIConnectionProperties)
    case verifyPin(params: PinParams, bankCode: String, connection: NIConnectionProperties)
    case changePin(params: ChangePinParams, bankCode: String, connection: NIConnectionProperties)
}

extension APIEndpoint: APIEndpointProtocol {
    
    var method: WSHTTPMethod {
        switch self {
        case .cardDetails, .cardsLookup, .setPin, .verifyPin, .changePin:
            return .POST
        case .pinCertificate:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .cardsLookup:
            return "/cards/lookup"
        case .cardDetails(_, let identifier, _, _, _):
            return "/cards/\(identifier)/secured"
        case .pinCertificate:
            return "/security/pin_certificate"
        case .setPin:
            return "/security/set_pin"
        case .verifyPin:
            return "/security/verify_pin"
        case .changePin:
            return "/security/change_pin"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .cardsLookup(let lookupParams, _, _):
            return lookupParams.toJson()
        case .cardDetails(let cardParams, _, _, _, _):
            return cardParams.toJson()
        case .setPin(let params, _, _):
            return params.toJson()
        case .verifyPin(let params, _, _):
            return params.toJson()
        case .changePin(let params, _, _):
            return params.toJson()
        default:
            return nil
        }
    }
    
    var queryParameters: [String : Any]? {
        switch self {
        case .cardDetails(_, _, let type, _, _):
            return ["card_identifier_type": type]
        default:
            return nil
        }
    }
    
    var token: String? {
        switch self {
        case .cardsLookup( _, _, let connection):
            return connection.token
        case .cardDetails(_, _, _, _, let connection):
            return connection.token
        case .pinCertificate(_, let connection):
            return connection.token
        case .setPin( _, _, let connection):
            return connection.token
        case .verifyPin( _, _, let connection):
            return connection.token
        case .changePin( _, _, let connection):
            return connection.token
        }
    }
    
    var rootUrl: String {
        switch self {
        case .cardsLookup( _, _, let connection):
            return connection.rootUrl
        case .cardDetails(_, _, _, _, let connection):
            return connection.rootUrl
        case .pinCertificate(_, let connection):
            return connection.rootUrl
        case .setPin( _, _, let connection):
            return connection.rootUrl
        case .verifyPin( _, _, let connection):
            return connection.rootUrl
        case .changePin( _, _, let connection):
            return connection.rootUrl
        }
    }
    
    var headers: Headers {
        return Headers(contentType: contentType, accept: accept, uniqueReferenceCode: uniqueReferenceCode, financialId: financialId, channelId: channelId)
    }
    
    private var accept: String {
        return "application/json"
    }
    
    private var contentType: String {
        return "application/json"
    }
    
    private var uniqueReferenceCode: String {
        return String.randomString(length: GlobalConfig.NIUniqueReferenceCodeLength)
    }
    
    private var financialId: String {
        switch self {
        case .cardsLookup(_, let bankCode, _):
            return bankCode
        case .cardDetails(_, _, _, let bankCode, _):
            return bankCode
        case .pinCertificate(let bankCode, _):
            return bankCode
        case .setPin(_, let bankCode, _):
            return bankCode
        case .verifyPin(_, let bankCode, _):
            return bankCode
        case .changePin(_, let bankCode, _):
            return bankCode
        }
    }
    
    private var channelId: String {
        return GlobalConfig.NIChannelId
    }
    
}
