//
// GetRestrictionsBody.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct GetRestrictionsBody: Codable, JSONEncodable, Hashable {

    static let cardIdentifierIdRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let cardIdentifierTypeRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let filterRule = StringRule(minLength: 1, maxLength: 255, pattern: nil)
    static let scopeCodeRule = StringRule(minLength: 1, maxLength: 1, pattern: nil)
    static let channelTypeRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    /** card identifier id */
    internal var cardIdentifierId: String
    /** CONTRACT_NUMBER  is used for clear card number or EXID which is a unique identifier for the card generated by CMS */
    internal var cardIdentifierType: String
    /** limit type can be list of usage codes (comma separated) */
    internal var filter: String?
    /** Scope code */
    internal var scopeCode: String?
    /** Type of channel */
    internal var channelType: String?

    internal init(cardIdentifierId: String, cardIdentifierType: String, filter: String? = nil, scopeCode: String? = nil, channelType: String? = nil) {
        self.cardIdentifierId = cardIdentifierId
        self.cardIdentifierType = cardIdentifierType
        self.filter = filter
        self.scopeCode = scopeCode
        self.channelType = channelType
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case cardIdentifierId = "card_identifier_id"
        case cardIdentifierType = "card_identifier_type"
        case filter
        case scopeCode = "scope_code"
        case channelType = "channel_type"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardIdentifierId, forKey: .cardIdentifierId)
        try container.encode(cardIdentifierType, forKey: .cardIdentifierType)
        try container.encodeIfPresent(filter, forKey: .filter)
        try container.encodeIfPresent(scopeCode, forKey: .scopeCode)
        try container.encodeIfPresent(channelType, forKey: .channelType)
    }
}

