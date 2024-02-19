//
// CardBalancesReq.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardBalancesReq: Codable, JSONEncodable, Hashable {

    internal var requestCardBalanceEnquiry: RequestCardBalanceEnquiry

    internal init(requestCardBalanceEnquiry: RequestCardBalanceEnquiry) {
        self.requestCardBalanceEnquiry = requestCardBalanceEnquiry
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case requestCardBalanceEnquiry = "request_card_balance_enquiry"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestCardBalanceEnquiry, forKey: .requestCardBalanceEnquiry)
    }
}

