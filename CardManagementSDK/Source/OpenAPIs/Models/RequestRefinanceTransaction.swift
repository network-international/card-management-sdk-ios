//
// RequestRefinanceTransaction.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct RequestRefinanceTransaction: Codable, JSONEncodable, Hashable {

    internal var header: RefinanceTransactionHeader
    internal var body: RefinanceTransactionBody?

    internal init(header: RefinanceTransactionHeader, body: RefinanceTransactionBody? = nil) {
        self.header = header
        self.body = body
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case header
        case body
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(header, forKey: .header)
        try container.encodeIfPresent(body, forKey: .body)
    }
}

