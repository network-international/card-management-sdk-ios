//
// SwitchRestrictionsUsageDetailsRes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct SwitchRestrictionsUsageDetailsRes: Codable, JSONEncodable, Hashable {

    internal var responseEnableDisableRestriction: ResponseSwitchRestrictionsUsageDetails

    internal init(responseEnableDisableRestriction: ResponseSwitchRestrictionsUsageDetails) {
        self.responseEnableDisableRestriction = responseEnableDisableRestriction
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case responseEnableDisableRestriction = "response_enable_disable_restriction"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(responseEnableDisableRestriction, forKey: .responseEnableDisableRestriction)
    }
}
