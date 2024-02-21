//
//  NSError+Utils.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation

private enum Constants {
    static let errorDomain        = "net.networkinternational.CardManagementSDK"
    static let errorKey           = "NICardManagementSDKMessage"
    static let errorDebugKey      = "NICardManagementSDKDebugMessage"
}

extension NSError {
    
    class func unexpectedError(debugMessage: String? = nil, code: Int = -1) -> NSError {
        let error = niError("Unexpected Error", debugMessage: debugMessage, code: code)
        return error
    }
    
    class func niError(_ message: String? = nil, debugMessage: String? = nil, code: Int = ErrorCodes.unknown) -> NSError {
        var userInfo: [String: String] = [:]
        
        if message != nil {
            userInfo[Constants.errorKey] = message
        }
        
        if debugMessage != nil {
            userInfo[Constants.errorDebugKey] = debugMessage
        }
        
        let error = NSError(domain: Constants.errorDomain,
                            code: code,
                            userInfo: userInfo)
        return error
    }
    
}

struct ErrorCodes {
    
    static let unknown = -1
}
