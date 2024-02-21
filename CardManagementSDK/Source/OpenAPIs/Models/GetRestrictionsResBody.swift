//
// GetRestrictionsResBody.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct GetRestrictionsResBody: Codable, JSONEncodable, Hashable {

    internal var restrictions: [Restrictions]?

    internal init(restrictions: [Restrictions]? = nil) {
        self.restrictions = restrictions
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case restrictions
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(restrictions, forKey: .restrictions)
    }
}
