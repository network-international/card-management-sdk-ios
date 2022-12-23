//
//  NIInput.swift
//  CardManagementSDK
//
//  Created by Paula Radu on 04.10.2022.
//

import Foundation

@objc public class NIInput: NSObject {
    public var bankCode: String
    public var cardIdentifierId: String
    public var cardIdentifierType: String
    public var connectionProperties: NIConnectionProperties
    public var displayAttributes: NIDisplayAttributes? = nil
    
    @objc public init(bankCode: String, cardIdentifierId: String, cardIdentifierType: String, connectionProperties: NIConnectionProperties, displayAttributes: NIDisplayAttributes? = nil) {
        self.bankCode = bankCode
        self.cardIdentifierId = cardIdentifierId
        self.cardIdentifierType = cardIdentifierType
        self.connectionProperties = connectionProperties
        self.displayAttributes = displayAttributes
    }
    
}
