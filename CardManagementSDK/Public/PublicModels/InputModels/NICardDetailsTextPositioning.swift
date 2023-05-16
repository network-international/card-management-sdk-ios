//
//  NICardDetailsTextPositioning.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 12.05.2023.
//

import Foundation

@objc public class NICardDetailsTextPositioning: NSObject {
    var leftAlignment: Double
    var cardNumberGroupTopAlignment: Double
    var dateCvvGroupTopAlignment: Double
    var cardHolderNameGroupTopAlignment: Double
    
    @objc public init(leftAlignment: Double, cardNumberGroupTopAlignment: Double, dateCvvGroupTopAlignment: Double, cardHolderNameGroupTopAlignment: Double) {
        self.leftAlignment = leftAlignment
        self.cardNumberGroupTopAlignment = cardNumberGroupTopAlignment
        self.dateCvvGroupTopAlignment = dateCvvGroupTopAlignment
        self.cardHolderNameGroupTopAlignment = cardHolderNameGroupTopAlignment
    }
}
