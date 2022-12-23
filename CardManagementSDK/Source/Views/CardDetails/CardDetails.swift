//
//  CardDetails.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 10.10.2022.
//

import Foundation

struct CardDetails {
    var cardNumberLabel: String
    var cardNumber: String?
    var maskedCardNumber: String?
    var cardholderName: String?
    var cardExpiryLabel: String
    var cardExpiry: String?
    var cvv2Label: String
    var cvv2: String?
    var cardholderNameLabel: String?
}


extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func separate(every stride: Int, with separator: Character) -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}
