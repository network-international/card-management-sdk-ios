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
        
        if let responseError = response.error {
            isError = true
            errorCode = String(responseError.code)
            errorMessage = responseError.localizedDescription
            return self
        }
        
        guard let data = response.data else {
            isError = true
            errorCode = String(response.code)
            errorMessage = "Unknown (no data)"
            return self
        }
        
        if response.code == 200 {
            isError = false
            return nil
        } else {
            
            guard let json = try? JSON.dataToJson(data).toDictionary() else {
                isError = true
                errorCode = String(response.code)
                errorMessage = String(data: data, encoding: .utf8) ?? "Unknown (JSON error)"
                return self
            }
            
            isError = true
            errorCode = json[NIErrorConstants.errorCode] as? String ?? String(response.code)
            errorMessage = json[NIErrorConstants.errorDescription] as? String ?? json[ResponseConstants.message] as? String ?? "Unknown"
            return self
        }
    }
}


enum NISDKErrors: String {
    case GENERAL_ERROR = "SDK General Error"
    case NAV_ERROR = "Form not allowed pushing on navigation controller"
    
    case NETWORK_ERROR = "Server Request Error"
    case PARSING_ERROR = "SDK Parsing Error"
    case NO_DATA_ERROR = "No Data Found"
    
    case RSAKEY_ERROR = "Couldn't get or generate Public Key"
    case PINBLOCK_ERROR = "PIN Block Error"
    case PINBLOCK_ENCRYPTION_ERROR = "PIN Block Encryption Error"
}
