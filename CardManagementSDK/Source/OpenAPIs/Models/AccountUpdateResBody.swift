//
// AccountUpdateResBody.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct AccountUpdateResBody: Codable, JSONEncodable, Hashable {

    static let accountNumberRule = StringRule(minLength: 1, maxLength: 64, pattern: nil)
    /** Account number */
    internal var accountNumber: String
    internal var customFields: [CustomFieldsCardCreate]?

    internal init(accountNumber: String, customFields: [CustomFieldsCardCreate]? = nil) {
        self.accountNumber = accountNumber
        self.customFields = customFields
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case accountNumber = "account_number"
        case customFields = "custom_fields"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accountNumber, forKey: .accountNumber)
        try container.encodeIfPresent(customFields, forKey: .customFields)
    }
}

