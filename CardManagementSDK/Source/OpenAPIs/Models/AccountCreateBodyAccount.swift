//
// AccountCreateBodyAccount.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct AccountCreateBodyAccount: Codable, JSONEncodable, Hashable {

    static let customerIdRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let accountNumberRule = StringRule(minLength: 1, maxLength: 64, pattern: nil)
    static let parentAccountNumberRule = StringRule(minLength: 1, maxLength: 64, pattern: nil)
    static let branchCodeRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    static let productCodeRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let billingDayRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    static let currencyRule = StringRule(minLength: 1, maxLength: 3, pattern: nil)
    /** Customer ID: Customer Identification number    This should be a unique number */
    internal var customerId: String
    /** Account number, if not provided CMS will generate it */
    internal var accountNumber: String?
    /** Parent account number - Applicable only for Corporate products */
    internal var parentAccountNumber: String?
    /** Branch Code, if no branches are used, the code must be same as bank_code */
    internal var branchCode: String
    /** Product code, this code is generated by CMS after creating the product, this code is FI spesific code 982_AED_002_A is just used as an example in Sandbox */
    internal var productCode: String
    /** Billing date, applicable only for credit card products */
    internal var billingDay: String?
    /** Informative value to the request, does not have any functional impact, the currency will be taken from the product */
    internal var currency: String
    internal var limit: AccountCreateBodyAccountLimit?
    internal var customFields: [CustomFieldsCardCreate]?

    internal init(customerId: String, accountNumber: String? = nil, parentAccountNumber: String? = nil, branchCode: String, productCode: String, billingDay: String? = nil, currency: String, limit: AccountCreateBodyAccountLimit? = nil, customFields: [CustomFieldsCardCreate]? = nil) {
        self.customerId = customerId
        self.accountNumber = accountNumber
        self.parentAccountNumber = parentAccountNumber
        self.branchCode = branchCode
        self.productCode = productCode
        self.billingDay = billingDay
        self.currency = currency
        self.limit = limit
        self.customFields = customFields
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case customerId = "customer_id"
        case accountNumber = "account_number"
        case parentAccountNumber = "parent_account_number"
        case branchCode = "branch_code"
        case productCode = "product_code"
        case billingDay = "billing_day"
        case currency
        case limit
        case customFields = "custom_fields"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(customerId, forKey: .customerId)
        try container.encodeIfPresent(accountNumber, forKey: .accountNumber)
        try container.encodeIfPresent(parentAccountNumber, forKey: .parentAccountNumber)
        try container.encode(branchCode, forKey: .branchCode)
        try container.encode(productCode, forKey: .productCode)
        try container.encodeIfPresent(billingDay, forKey: .billingDay)
        try container.encode(currency, forKey: .currency)
        try container.encodeIfPresent(limit, forKey: .limit)
        try container.encodeIfPresent(customFields, forKey: .customFields)
    }
}

