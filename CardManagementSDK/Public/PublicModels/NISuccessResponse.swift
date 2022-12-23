//
//  NISuccessResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation

@objc public class NISuccessResponse: NSObject {
    
    public var message: String
    
    init(message: String) {
        self.message = message
    }
    
}
