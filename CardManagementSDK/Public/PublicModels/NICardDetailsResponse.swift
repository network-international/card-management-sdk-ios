//
//  NICardDetailsResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 17.10.2022.
//

import Foundation


@objc public class NICardDetailsResponse: NSObject {
    
    public var clearPan: String?
    public var maskedPan: String?
    public var expiry: String?
    public var clearCVV2: String?
    public var cardholderName: String?
    
    public init(clearPan: String?, maskedPan: String?, expiry: String?, clearCVV2: String?, cardholderName: String?) {
        self.clearPan = clearPan
        self.maskedPan = maskedPan
        self.expiry = expiry
        self.clearCVV2 = clearCVV2
        self.cardholderName = cardholderName
    }
    
}
