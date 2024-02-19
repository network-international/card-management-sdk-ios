//
// CardsAccountHierarchy.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardsAccountHierarchy: Codable, JSONEncodable, Hashable {

    static let maskedCardNumberRule = StringRule(minLength: 1, maxLength: 16, pattern: nil)
    static let customerIdRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let cardIdentifierIdRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let cardIdentifierTypeRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let cardExpiryDateRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    static let cardholderNameRule = StringRule(minLength: 1, maxLength: 21, pattern: nil)
    static let productCodeRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let productNameRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let brandRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    static let cardVirtualIndicatorRule = StringRule(minLength: 1, maxLength: 1, pattern: nil)
    /** Masked PAN */
    internal var maskedCardNumber: String
    /** Customer ID: Customer Identification number    This should be a unique number */
    internal var customerId: String?
    /** Card Identifier Id */
    internal var cardIdentifierId: String
    /** CONTRACT_NUMBER is used for clear card number or EXID which is a unique identifier for the card generated by CMS */
    internal var cardIdentifierType: String
    /** Format YYMM */
    internal var cardExpiryDate: String
    /** Cardholder name */
    internal var cardholderName: String
    /** Product code */
    internal var productCode: String
    /** Product Name */
    internal var productName: String?
    /** Card Brand example: MC , Visa */
    internal var brand: String?
    /** V - Virtual P - Physical */
    internal var cardVirtualIndicator: String?
    internal var statuses: Statuses?
    internal var balances: Balances?

    internal init(maskedCardNumber: String, customerId: String? = nil, cardIdentifierId: String, cardIdentifierType: String, cardExpiryDate: String, cardholderName: String, productCode: String, productName: String? = nil, brand: String? = nil, cardVirtualIndicator: String? = nil, statuses: Statuses? = nil, balances: Balances? = nil) {
        self.maskedCardNumber = maskedCardNumber
        self.customerId = customerId
        self.cardIdentifierId = cardIdentifierId
        self.cardIdentifierType = cardIdentifierType
        self.cardExpiryDate = cardExpiryDate
        self.cardholderName = cardholderName
        self.productCode = productCode
        self.productName = productName
        self.brand = brand
        self.cardVirtualIndicator = cardVirtualIndicator
        self.statuses = statuses
        self.balances = balances
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case maskedCardNumber = "masked_card_number"
        case customerId = "customer_id"
        case cardIdentifierId = "card_identifier_id"
        case cardIdentifierType = "card_identifier_type"
        case cardExpiryDate = "card_expiry_date"
        case cardholderName = "cardholder_name"
        case productCode = "product_code"
        case productName = "product_name"
        case brand
        case cardVirtualIndicator = "card_virtual_indicator"
        case statuses
        case balances
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(maskedCardNumber, forKey: .maskedCardNumber)
        try container.encodeIfPresent(customerId, forKey: .customerId)
        try container.encode(cardIdentifierId, forKey: .cardIdentifierId)
        try container.encode(cardIdentifierType, forKey: .cardIdentifierType)
        try container.encode(cardExpiryDate, forKey: .cardExpiryDate)
        try container.encode(cardholderName, forKey: .cardholderName)
        try container.encode(productCode, forKey: .productCode)
        try container.encodeIfPresent(productName, forKey: .productName)
        try container.encodeIfPresent(brand, forKey: .brand)
        try container.encodeIfPresent(cardVirtualIndicator, forKey: .cardVirtualIndicator)
        try container.encodeIfPresent(statuses, forKey: .statuses)
        try container.encodeIfPresent(balances, forKey: .balances)
    }
}

