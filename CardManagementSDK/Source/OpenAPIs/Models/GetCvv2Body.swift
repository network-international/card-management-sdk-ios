//
// GetCvv2Body.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct GetCvv2Body: Codable, JSONEncodable, Hashable {

    static let cardIdentifierIdRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let cardIdentifierTypeRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let cardSequenceNumberRule = StringRule(minLength: 1, maxLength: 2, pattern: nil)
    static let expiryDateRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    /** card identifier */
    internal var cardIdentifierId: String
    /** CONTRACT_NUMBER  is used for clear card number or EXID which is a unique identifier for the card generated by CMS */
    internal var cardIdentifierType: String
    /** Sample 01 */
    internal var cardSequenceNumber: String?
    /** Expiry date of the card YYMM ex: 2310 */
    internal var expiryDate: String

    internal init(cardIdentifierId: String, cardIdentifierType: String, cardSequenceNumber: String? = nil, expiryDate: String) {
        self.cardIdentifierId = cardIdentifierId
        self.cardIdentifierType = cardIdentifierType
        self.cardSequenceNumber = cardSequenceNumber
        self.expiryDate = expiryDate
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case cardIdentifierId = "card_identifier_id"
        case cardIdentifierType = "card_identifier_type"
        case cardSequenceNumber = "card_sequence_number"
        case expiryDate = "expiry_date"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardIdentifierId, forKey: .cardIdentifierId)
        try container.encode(cardIdentifierType, forKey: .cardIdentifierType)
        try container.encodeIfPresent(cardSequenceNumber, forKey: .cardSequenceNumber)
        try container.encode(expiryDate, forKey: .expiryDate)
    }
}

