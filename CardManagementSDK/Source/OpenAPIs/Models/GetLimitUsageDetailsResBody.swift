//
// GetLimitUsageDetailsResBody.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct GetLimitUsageDetailsResBody: Codable, JSONEncodable, Hashable {

    internal var limits: [Limits]?

    internal init(limits: [Limits]? = nil) {
        self.limits = limits
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case limits
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(limits, forKey: .limits)
    }
}
