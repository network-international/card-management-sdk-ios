//
//  NICardDetailsResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 17.10.2022.
//

import Foundation


@objc public class NICardDetailsResponse: NSObject {
    
    var clearPan: String?
    var maskedPan: String?
    var expiry: String?
    var clearCVV2: String?
    var cardholderName: String?
    
    init(clearPan: String?, maskedPan: String?, expiry: String?, clearCVV2: String?, cardholderName: String?) {
        self.clearPan = clearPan
        self.maskedPan = maskedPan
        self.expiry = expiry
        self.clearCVV2 = clearCVV2
        self.cardholderName = cardholderName
    }
    
}
