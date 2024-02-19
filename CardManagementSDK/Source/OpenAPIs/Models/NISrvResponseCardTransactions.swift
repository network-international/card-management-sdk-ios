//
// NISrvResponseCardTransactions.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct NISrvResponseCardTransactions: Codable, JSONEncodable, Hashable {

    internal var nISrvResponse: CardTransactionsRes

    internal init(nISrvResponse: CardTransactionsRes) {
        self.nISrvResponse = nISrvResponse
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case nISrvResponse = "NISrvResponse"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nISrvResponse, forKey: .nISrvResponse)
    }
}

