//
//  NIErrorResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation

struct NIErrorConstants {
    static let errorCode = "error_code"
    static let errorDescription = "error_description"
}

@objc public class NIErrorResponse: NSObject {
    
    public var errorCode: String = ""
    public var errorMessage: String = ""
    var isError = false
    
    override init() {}
    
    init(error: NISDKErrors) {
        errorMessage = error.rawValue
    }
    
    func withResponse(response: Response) -> NIErrorResponse? {
        
        if response.code == 200 {
            isError = false
            return nil
        }
        
        guard let data = response.data else {
            isError = true
            errorCode = String(response.code)
            errorMessage = "Unknown (no data)"
            return self
        }
        
        guard let json = try? JSON.dataToJson(data).toDictionary() else {
            isError = true
            errorCode = String(response.code)
            errorMessage = String(data: data, encoding: .utf8) ?? "Unknown (JSON error)"
            return self
        }
        
        if response.code == 400 {
            isError = true
            errorCode = json[NIErrorConstants.errorCode] as? String ?? String(response.code)
            errorMessage = json[NIErrorConstants.errorDescription] as? String ?? "Unknown"
            return self
        }
        
        if response.code == 500 {
            isError = true
            errorCode = String(response.code)
            errorMessage = json[NIErrorConstants.errorDescription] as? String ?? "Unknown"
            return self
        }
        
        if json[NIErrorConstants.errorCode] == nil {
            isError = false
            return nil
        }
        
        return self
    }
}


enum NISDKErrors: String {
    case GENERAL_ERROR = "SDK General Error"
    case NAV_ERROR = "Form not allowed pushing on navigation controller"
    
    case NETWORK_ERROR = "Server Request Error"
    case PARSING_ERROR = "SDK Parsing Error"
    
    case RSAKEY_ERROR = "Couldn't get or generate Public Key"
    case PINBLOCK_ERROR = "PIN Block Error"
    case PINBLOCK_ENCRYPTION_ERROR = "PIN Block Encryption Error"
}
