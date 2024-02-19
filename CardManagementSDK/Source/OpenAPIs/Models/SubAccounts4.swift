//
// SubAccounts4.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct SubAccounts4: Codable, JSONEncodable, Hashable {

    static let accountNumberRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let customerIdRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let rbsNumberRule = StringRule(minLength: 1, maxLength: 512, pattern: nil)
    static let productCodeRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    /** Account number */
    internal var accountNumber: String
    /** Customer ID: Customer Identification number    This should be a unique number */
    internal var customerId: String
    /** RBS Number which is the number used to link NI System with Core System */
    internal var rbsNumber: String?
    /** Product code, this code is generated by CMS after creating the product, this code is FI spesific code 982_AED_045_C_2 is just used as an example in Sandbox */
    internal var productCode: String
    internal var balances: Balances?
    internal var cards: CardsAccountHierarchy?

    internal init(accountNumber: String, customerId: String, rbsNumber: String? = nil, productCode: String, balances: Balances? = nil, cards: CardsAccountHierarchy? = nil) {
        self.accountNumber = accountNumber
        self.customerId = customerId
        self.rbsNumber = rbsNumber
        self.productCode = productCode
        self.balances = balances
        self.cards = cards
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case accountNumber = "account_number"
        case customerId = "customer_id"
        case rbsNumber = "rbs_number"
        case productCode = "product_code"
        case balances
        case cards
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountNumber, forKey: .accountNumber)
        try container.encode(customerId, forKey: .customerId)
        try container.encodeIfPresent(rbsNumber, forKey: .rbsNumber)
        try container.encode(productCode, forKey: .productCode)
        try container.encodeIfPresent(balances, forKey: .balances)
        try container.encodeIfPresent(cards, forKey: .cards)
    }
}

