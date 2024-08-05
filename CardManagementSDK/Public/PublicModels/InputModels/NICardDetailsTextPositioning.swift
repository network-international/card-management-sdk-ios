//
//  NICardDetailsTextPositioning.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 12.05.2023.
//

import Foundation

public struct NICardDetailsTextPositioning {
    var leftAlignment: Double
    var cardNumberGroupTopAlignment: Double
    var dateCvvGroupTopAlignment: Double
    var cardHolderNameGroupTopAlignment: Double
    
    public init(leftAlignment: Double, cardNumberGroupTopAlignment: Double, dateCvvGroupTopAlignment: Double, cardHolderNameGroupTopAlignment: Double) {
        self.leftAlignment = leftAlignment
        self.cardNumberGroupTopAlignment = cardNumberGroupTopAlignment
        self.dateCvvGroupTopAlignment = dateCvvGroupTopAlignment
        self.cardHolderNameGroupTopAlignment = cardHolderNameGroupTopAlignment
    }
}
