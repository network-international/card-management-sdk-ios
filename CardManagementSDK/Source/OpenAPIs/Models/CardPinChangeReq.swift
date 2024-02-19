//
// CardPinChangeReq.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardPinChangeReq: Codable, JSONEncodable, Hashable {

    internal var requestCardPinChange: RequestCardPinChange

    internal init(requestCardPinChange: RequestCardPinChange) {
        self.requestCardPinChange = requestCardPinChange
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case requestCardPinChange = "request_card_pin_change"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestCardPinChange, forKey: .requestCardPinChange)
    }
}

