//
// GetListOfCardsReq.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct GetListOfCardsReq: Codable, JSONEncodable, Hashable {

    internal var requestListOfCards: RequestListOfCards

    internal init(requestListOfCards: RequestListOfCards) {
        self.requestListOfCards = requestListOfCards
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case requestListOfCards = "request_list_of_cards"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestListOfCards, forKey: .requestListOfCards)
    }
}
