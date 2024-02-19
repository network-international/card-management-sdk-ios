//
// GetCardTransactionsBody.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct GetCardTransactionsBody: Codable, JSONEncodable, Hashable {

    static let cardIdentifierIdRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let cardIdentifierTypeRule = StringRule(minLength: 1, maxLength: 20, pattern: nil)
    static let transactionTypeRule = StringRule(minLength: 1, maxLength: 16, pattern: nil)
    static let dateFromRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    static let dateToRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    static let statementPeriodRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    static let noOfTransactionsRequestedRule = StringRule(minLength: 1, maxLength: 2, pattern: nil)
    static let requestedPageNoRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    static let returnMccGroupRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    /** Card Identifier */
    internal var cardIdentifierId: String
    /** CONTRACT_NUMBER is used for clear card number or EXID which is a unique identifier for the card generated by CMS */
    internal var cardIdentifierType: String
    /** authorized, time_based/posted, statemented */
    internal var transactionType: String
    /** Format DD/MM/YYYY. Maximum interval is 90days. Conditional for posted. */
    internal var dateFrom: String?
    /** Format DD/MM/YYYY. Maximum interval is 90days.Conditional for posted */
    internal var dateTo: String?
    /** Format YYMM (Maximum statement is 12 months from the current date). */
    internal var statementPeriod: String?
    /** Maximum number of transactions to be fetched in a request. Value should be between 1 and 99 default is 50        */
    internal var noOfTransactionsRequested: String?
    /** Page number of the current request, could be from 1 to 99.     */
    internal var requestedPageNo: String?
    /** To retrun MCC group */
    internal var returnMccGroup: String?

    internal init(cardIdentifierId: String, cardIdentifierType: String, transactionType: String, dateFrom: String? = nil, dateTo: String? = nil, statementPeriod: String? = nil, noOfTransactionsRequested: String? = nil, requestedPageNo: String? = nil, returnMccGroup: String? = nil) {
        self.cardIdentifierId = cardIdentifierId
        self.cardIdentifierType = cardIdentifierType
        self.transactionType = transactionType
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.statementPeriod = statementPeriod
        self.noOfTransactionsRequested = noOfTransactionsRequested
        self.requestedPageNo = requestedPageNo
        self.returnMccGroup = returnMccGroup
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case cardIdentifierId = "card_identifier_id"
        case cardIdentifierType = "card_identifier_type"
        case transactionType = "transaction_type"
        case dateFrom = "date_from"
        case dateTo = "date_to"
        case statementPeriod = "statement_period"
        case noOfTransactionsRequested = "no_of_transactions_requested"
        case requestedPageNo = "requested_page_no"
        case returnMccGroup = "return_mcc_group"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cardIdentifierId, forKey: .cardIdentifierId)
        try container.encode(cardIdentifierType, forKey: .cardIdentifierType)
        try container.encode(transactionType, forKey: .transactionType)
        try container.encodeIfPresent(dateFrom, forKey: .dateFrom)
        try container.encodeIfPresent(dateTo, forKey: .dateTo)
        try container.encodeIfPresent(statementPeriod, forKey: .statementPeriod)
        try container.encodeIfPresent(noOfTransactionsRequested, forKey: .noOfTransactionsRequested)
        try container.encodeIfPresent(requestedPageNo, forKey: .requestedPageNo)
        try container.encodeIfPresent(returnMccGroup, forKey: .returnMccGroup)
    }
}

