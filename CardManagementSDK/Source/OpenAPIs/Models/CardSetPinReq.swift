//
// CardSetPinReq.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardSetPinReq: Codable, JSONEncodable, Hashable {

    internal var requestCardSetPin: RequestCardSetPin

    internal init(requestCardSetPin: RequestCardSetPin) {
        self.requestCardSetPin = requestCardSetPin
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case requestCardSetPin = "request_card_set_pin"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestCardSetPin, forKey: .requestCardSetPin)
    }
}
