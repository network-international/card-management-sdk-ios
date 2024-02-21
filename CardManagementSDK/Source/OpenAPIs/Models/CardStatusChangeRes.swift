//
// CardStatusChangeRes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardStatusChangeRes: Codable, JSONEncodable, Hashable {

    internal var responseCardStatusChange: ResponseCardStatusChange

    internal init(responseCardStatusChange: ResponseCardStatusChange) {
        self.responseCardStatusChange = responseCardStatusChange
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case responseCardStatusChange = "response_card_status_change"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(responseCardStatusChange, forKey: .responseCardStatusChange)
    }
}
