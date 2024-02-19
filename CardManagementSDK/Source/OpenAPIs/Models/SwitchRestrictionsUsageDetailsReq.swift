//
// SwitchRestrictionsUsageDetailsReq.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct SwitchRestrictionsUsageDetailsReq: Codable, JSONEncodable, Hashable {

    internal var requestEnableDisableRestriction: RequestSwitchRestrictionsUsageDetails

    internal init(requestEnableDisableRestriction: RequestSwitchRestrictionsUsageDetails) {
        self.requestEnableDisableRestriction = requestEnableDisableRestriction
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case requestEnableDisableRestriction = "request_enable_disable_restriction"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestEnableDisableRestriction, forKey: .requestEnableDisableRestriction)
    }
}

