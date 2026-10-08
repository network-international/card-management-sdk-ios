//
//  NIConnectionProperties.swift
//  CardManagementSDK
//
//  Created by Paula Radu on 04.10.2022.
//

import Foundation

@objc public class NIConnectionProperties: NSObject {
    public var rootUrl: String
    public var token: String
    
    @objc public init(rootUrl: String, token: String) {
        self.rootUrl = rootUrl
        self.token = token
    }
    
}
