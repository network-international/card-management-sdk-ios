//
//  NSError+Utils.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation


extension NSError {
    
    class func unexpectedError(debugMessage: String? = nil, code: Int = -1) -> NSError {
        let error = niError("Unexpected Error", debugMessage: debugMessage, code: code)
        return error
    }
    
    class func niError(_ message: String? = nil, debugMessage: String? = nil, code: Int = ErrorCodes.Unknown) -> NSError {
        var userInfo: [String: String] = [:]
        
        if message != nil {
            userInfo[GlobalConfig.NIErrorKey] = message
        }
        
        if debugMessage != nil {
            userInfo[GlobalConfig.NIErrorDebugKey] = debugMessage
        }
        
        let error = NSError(domain: GlobalConfig.NIErrorDomain,
                            code: code,
                            userInfo: userInfo)
        return error
    }
    
}

struct ErrorCodes {
    
    static let Unknown = -1
}
