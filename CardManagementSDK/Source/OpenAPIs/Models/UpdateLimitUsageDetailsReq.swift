//
// UpdateLimitUsageDetailsReq.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct UpdateLimitUsageDetailsReq: Codable, JSONEncodable, Hashable {

    internal var requestUpdateUsageLimiter: RequestUpdateLimiterUsageDetails

    internal init(requestUpdateUsageLimiter: RequestUpdateLimiterUsageDetails) {
        self.requestUpdateUsageLimiter = requestUpdateUsageLimiter
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case requestUpdateUsageLimiter = "request_update_usage_limiter"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestUpdateUsageLimiter, forKey: .requestUpdateUsageLimiter)
    }
}
