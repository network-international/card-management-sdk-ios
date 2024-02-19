//
// ResponseSwitchRestrictionsUsageDetails.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct ResponseSwitchRestrictionsUsageDetails: Codable, JSONEncodable, Hashable {

    internal var header: SwitchRestrictionsUsageDetailsResHeader
    internal var exceptionDetails: ExceptionDetails

    internal init(header: SwitchRestrictionsUsageDetailsResHeader, exceptionDetails: ExceptionDetails) {
        self.header = header
        self.exceptionDetails = exceptionDetails
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case header
        case exceptionDetails = "exception_details"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(header, forKey: .header)
        try container.encode(exceptionDetails, forKey: .exceptionDetails)
    }
}

