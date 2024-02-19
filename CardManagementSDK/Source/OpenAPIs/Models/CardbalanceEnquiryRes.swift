//
// CardbalanceEnquiryRes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardbalanceEnquiryRes: Codable, JSONEncodable, Hashable {

    internal var responseCardBalanceEnquiry: ResponseCardBalanceEnquiry

    internal init(responseCardBalanceEnquiry: ResponseCardBalanceEnquiry) {
        self.responseCardBalanceEnquiry = responseCardBalanceEnquiry
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case responseCardBalanceEnquiry = "response_card_balance_enquiry"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(responseCardBalanceEnquiry, forKey: .responseCardBalanceEnquiry)
    }
}

