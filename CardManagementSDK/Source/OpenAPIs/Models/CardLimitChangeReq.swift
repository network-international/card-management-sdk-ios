//
// CardLimitChangeReq.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardLimitChangeReq: Codable, JSONEncodable, Hashable {

    internal var requestCardLimitChange: RequestCardLimitChange

    internal init(requestCardLimitChange: RequestCardLimitChange) {
        self.requestCardLimitChange = requestCardLimitChange
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case requestCardLimitChange = "request_card_limit_change"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestCardLimitChange, forKey: .requestCardLimitChange)
    }
}
