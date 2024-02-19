//
// AccountUpdateBody.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct AccountUpdateBody: Codable, JSONEncodable, Hashable {

    static let accountNumberRule = StringRule(minLength: 1, maxLength: 64, pattern: nil)
    static let cardTypeRule = StringRule(minLength: 1, maxLength: 7, pattern: nil)
    /** Account number */
    internal var accountNumber: String
    /** Informative value to the request, does not have any functional impact, the value can be PREPAID/CREDIT/DEBIT */
    internal var cardType: String
    internal var account: AccountUpdateBodyAccount

    internal init(accountNumber: String, cardType: String, account: AccountUpdateBodyAccount) {
        self.accountNumber = accountNumber
        self.cardType = cardType
        self.account = account
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case accountNumber = "account_number"
        case cardType = "card_type"
        case account
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountNumber, forKey: .accountNumber)
        try container.encode(cardType, forKey: .cardType)
        try container.encode(account, forKey: .account)
    }
}

