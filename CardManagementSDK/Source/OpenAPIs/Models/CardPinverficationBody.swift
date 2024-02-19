//
// CardPinverficationBody.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardPinverficationBody: Codable, JSONEncodable, Hashable {

    static let cardIdentifierIdRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let cardIdentifierTypeRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let cardExpiryDateRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    static let encryptedPinRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let encryptionMethodRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    /** card identifier */
    internal var cardIdentifierId: String
    /** CONTRACT_NUMBER  is used for clear card number or EXID which is a unique identifier for the card generated by CMS */
    internal var cardIdentifierType: String
    /** YYMM Ex: 2310 */
    internal var cardExpiryDate: String?
    /** Encrypted Pin block of the pin to be set. Ex: 7B47D3321D4A5F63 */
    internal var encryptedPin: String
    /** Encryption Method to be used for the encryption of the pin */
    internal var encryptionMethod: String?

    internal init(cardIdentifierId: String, cardIdentifierType: String, cardExpiryDate: String? = nil, encryptedPin: String, encryptionMethod: String? = nil) {
        self.cardIdentifierId = cardIdentifierId
        self.cardIdentifierType = cardIdentifierType
        self.cardExpiryDate = cardExpiryDate
        self.encryptedPin = encryptedPin
        self.encryptionMethod = encryptionMethod
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case cardIdentifierId = "card_identifier_id"
        case cardIdentifierType = "card_identifier_type"
        case cardExpiryDate = "card_expiry_date"
        case encryptedPin = "encrypted_pin"
        case encryptionMethod = "encryption_method"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardIdentifierId, forKey: .cardIdentifierId)
        try container.encode(cardIdentifierType, forKey: .cardIdentifierType)
        try container.encodeIfPresent(cardExpiryDate, forKey: .cardExpiryDate)
        try container.encode(encryptedPin, forKey: .encryptedPin)
        try container.encodeIfPresent(encryptionMethod, forKey: .encryptionMethod)
    }
}

