//
//  NIErrorResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation

private enum NIErrorConstants {
    static let errorCode = "error_code"
    static let errorDescription = "error_description"
    static let message = "message"
}

public class NIErrorResponse {
    
    public let errorCode: String
    public let errorMessage: String
    
    init(error: NISDKError) {
        errorCode = error.legacyCode
        errorMessage = error.legacyText
    }
    
    static var wrongNavigation: NIErrorResponse { .init(error: .navigationError) }
}


enum NISDKError: Error {
    case rsaKeyError(_ error: KeychainError?)
    case cryptoError(_ error: RSADecryptError?)
    case responseError(Int, Data?, URLResponse?, Error)
    // TODO: get rid of it as it should be `responseError`
    case networkError(_ error: Error?)
    // TODO: remove it as it contains mostly network errors
    case tokenError(_ error: TokenError)
    
    case navigationError
    
    var legacyText: String {
        switch self {
        case .rsaKeyError: return "Couldn't get or generate Public Key"
        case .cryptoError: return "Encryption Error"
        // "SDK General Error"
        case let .responseError(code, data, resp, error):
            return Self.parseResponse(code: code, data: data, resp: resp, error: error).errorMessage
        case .networkError: return "Server Request Error"
        case .tokenError: return "Token Error"
        case .navigationError: return "Navigation error"
        }
    }
    
    var legacyCode: String {
        switch self {
        case let .rsaKeyError(keychainError):
            return keychainError.flatMap { "\($0.errorCode)" } ?? ""
        case let .cryptoError(rsaError):
            return rsaError.flatMap { "\($0.errorCode)" } ?? ""
        case let .responseError(code, data, resp, error):
            return Self.parseResponse(code: code, data: data, resp: resp, error: error).errorCode
        case let .networkError(error):
            return error.flatMap { "\(($0 as NSError).code)" } ?? ""
        case let .tokenError(tokenError): 
            return "\(tokenError.errorCode)"
        case .navigationError: return "-2"
        }
    }
    
    private static func parseResponse(code: Int, data: Data?, resp: URLResponse?, error: Error) -> (errorCode: String, errorMessage: String) {
        var errorCode: String
        var errorMessage: String
        // parse data
        if let data = data {
            if let json = try? JSON.dataToJson(data).toDictionary() {
                errorCode = json[NIErrorConstants.errorCode] as? String ?? String(code)
                errorMessage = json[NIErrorConstants.errorDescription] as? String ?? json[NIErrorConstants.message] as? String ?? error.localizedDescription //"Unknown"
            } else {
                errorCode = String(code) // (resp as? HTTPURLResponse)?.statusCode
                errorMessage = String(data: data, encoding: .utf8) ?? "Unknown (JSON error)"
            }
        } else {
            errorCode = String((error as NSError).code)
            errorMessage = error.localizedDescription
            //errorCode = String(code) // (resp as? HTTPURLResponse)?.statusCode
            //errorMessage = "Unknown (no data)"
        }
        return (errorCode, errorMessage)
    }
}

private extension KeychainError {
    var errorCode: Int {
        switch self {
        case let .certCreationFailed(status): return Int(status ?? -1)
        case let .unhandledError(status): return Int(status ?? -1)
        case let .generateKeyFailed(error): return (error as NSError).code
        default: return -1
        }
    }
}

private extension RSADecryptError {
    var errorCode: Int {
        switch self {
        case let .decryptError(error): return (error as NSError).code
        default: return -1
        }
    }
}

private extension TokenError {
    var errorCode: Int {
        switch self {
        case let .networkError(error): return (error as NSError).code
        default: return -1
        }
    }
}
