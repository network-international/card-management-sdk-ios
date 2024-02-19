//
// Listofcardsbalances.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct Listofcardsbalances: Codable, JSONEncodable, Hashable {

    static let typeRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let currencyRule = StringRule(minLength: 1, maxLength: 5, pattern: nil)
    static let descriptionRule = StringRule(minLength: 1, maxLength: 100, pattern: nil)
    /** Balance type */
    internal var type: String
    /** Currency */
    internal var currency: String
    /** Description */
    internal var description: String?

    internal init(type: String, currency: String, description: String? = nil) {
        self.type = type
        self.currency = currency
        self.description = description
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case type
        case currency
        case description
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(currency, forKey: .currency)
        try container.encodeIfPresent(description, forKey: .description)
    }
}

