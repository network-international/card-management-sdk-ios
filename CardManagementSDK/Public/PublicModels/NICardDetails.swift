//
//  NICardDetails.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 17.10.2022.
//

import Foundation


public class NICardDetails {
    
    public let clearPan: String?
    public let maskedPan: String?
    public let expiry: String?
    public let clearCVV2: String?
    public let cardholderName: String?
    
    init(response: NICardDetailsClearResponse) {
        self.clearPan = response.cardNumber
        self.maskedPan = response.maskedPan
        self.expiry = response.expiryDate
        self.clearCVV2 = response.cvv2
        self.cardholderName = response.cardholderName
    }
}
