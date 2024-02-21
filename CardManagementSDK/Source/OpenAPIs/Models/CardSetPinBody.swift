//
// CardSetPinBody.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardSetPinBody: Codable, JSONEncodable, Hashable {

    static let cardIdentifierIdRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let cardIdentifierTypeRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let cardSequenceNumberRule = StringRule(minLength: 1, maxLength: 2, pattern: nil)
    static let cardExpiryDateRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    static let encryptedPinRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let encryptionMethodRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    /** Card Identifier Id */
    internal var cardIdentifierId: String
    /** CONTRACT_NUMBER is used for clear card number or EXID which is a unique identifier for the card generated by CMS */
    internal var cardIdentifierType: String
    /** Sample 01 */
    internal var cardSequenceNumber: String?
    /** 2605 */
    internal var cardExpiryDate: String
    /** 7B47D3321D4A5F63 */
    internal var encryptedPin: String
    /** SYMMETRIC_ENC */
    internal var encryptionMethod: String

    internal init(cardIdentifierId: String, cardIdentifierType: String, cardSequenceNumber: String? = nil, cardExpiryDate: String, encryptedPin: String, encryptionMethod: String) {
        self.cardIdentifierId = cardIdentifierId
        self.cardIdentifierType = cardIdentifierType
        self.cardSequenceNumber = cardSequenceNumber
        self.cardExpiryDate = cardExpiryDate
        self.encryptedPin = encryptedPin
        self.encryptionMethod = encryptionMethod
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case cardIdentifierId = "card_identifier_id"
        case cardIdentifierType = "card_identifier_type"
        case cardSequenceNumber = "card_sequence_number"
        case cardExpiryDate = "card_expiry_date"
        case encryptedPin = "encrypted_pin"
        case encryptionMethod = "encryption_method"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardIdentifierId, forKey: .cardIdentifierId)
        try container.encode(cardIdentifierType, forKey: .cardIdentifierType)
        try container.encodeIfPresent(cardSequenceNumber, forKey: .cardSequenceNumber)
        try container.encode(cardExpiryDate, forKey: .cardExpiryDate)
        try container.encode(encryptedPin, forKey: .encryptedPin)
        try container.encode(encryptionMethod, forKey: .encryptionMethod)
    }
}
