//
// UpdateUsageLimiterRes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct UpdateUsageLimiterRes: Codable, JSONEncodable, Hashable {

    internal var responseUpdateUsageLimiter: ResponseUpdateUsageLimiter

    internal init(responseUpdateUsageLimiter: ResponseUpdateUsageLimiter) {
        self.responseUpdateUsageLimiter = responseUpdateUsageLimiter
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case responseUpdateUsageLimiter = "response_update_usage_limiter"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(responseUpdateUsageLimiter, forKey: .responseUpdateUsageLimiter)
    }
}
