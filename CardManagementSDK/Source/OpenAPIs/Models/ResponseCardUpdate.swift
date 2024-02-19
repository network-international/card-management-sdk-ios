//
// ResponseCardUpdate.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct ResponseCardUpdate: Codable, JSONEncodable, Hashable {

    internal var header: CardUpdateResHeader
    internal var exceptionDetails: ExceptionDetails
    internal var body: CardUpdateResBody?

    internal init(header: CardUpdateResHeader, exceptionDetails: ExceptionDetails, body: CardUpdateResBody? = nil) {
        self.header = header
        self.exceptionDetails = exceptionDetails
        self.body = body
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case header
        case exceptionDetails = "exception_details"
        case body
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(header, forKey: .header)
        try container.encode(exceptionDetails, forKey: .exceptionDetails)
        try container.encodeIfPresent(body, forKey: .body)
    }
}

