//
// AccountHierarchyEnquiryResHeader.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct AccountHierarchyEnquiryResHeader: Codable, JSONEncodable, Hashable {

    static let msgIdRule = StringRule(minLength: 1, maxLength: 12, pattern: nil)
    static let msgTypeRule = StringRule(minLength: 1, maxLength: 12, pattern: nil)
    static let msgFunctionRule = StringRule(minLength: 1, maxLength: 50, pattern: nil)
    static let srcApplicationRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    static let targetApplicationRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    static let timestampRule = StringRule(minLength: 1, maxLength: 30, pattern: nil)
    static let trackingIdRule = StringRule(minLength: 1, maxLength: 15, pattern: nil)
    static let bankIdRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    /** Unique Source Message ID */
    internal var msgId: String
    /** Message Type – This can have either “TRANSACTION” or “ENQUIRY”    As for this API the value expected is “ENQUIRY”  */
    internal var msgType: String
    /** Static Value -  REQ_CARD_DETAILS */
    internal var msgFunction: String
    /** Source requesting channel Ex IVR */
    internal var srcApplication: String
    /** Target application name Ex PCMS */
    internal var targetApplication: String
    /** Timestamp of the request - Format  YYYY-MM-DDtHH:MM:SS.SSS+04:00 */
    internal var timestamp: String
    /** Transaction Tracking Id */
    internal var trackingId: String?
    /** Source Bank Id Ex bankID */
    internal var bankId: String

    internal init(msgId: String, msgType: String, msgFunction: String, srcApplication: String, targetApplication: String, timestamp: String, trackingId: String? = nil, bankId: String) {
        self.msgId = msgId
        self.msgType = msgType
        self.msgFunction = msgFunction
        self.srcApplication = srcApplication
        self.targetApplication = targetApplication
        self.timestamp = timestamp
        self.trackingId = trackingId
        self.bankId = bankId
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case msgId = "msg_id"
        case msgType = "msg_type"
        case msgFunction = "msg_function"
        case srcApplication = "src_application"
        case targetApplication = "target_application"
        case timestamp
        case trackingId = "tracking_id"
        case bankId = "bank_id"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(msgId, forKey: .msgId)
        try container.encode(msgType, forKey: .msgType)
        try container.encode(msgFunction, forKey: .msgFunction)
        try container.encode(srcApplication, forKey: .srcApplication)
        try container.encode(targetApplication, forKey: .targetApplication)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(trackingId, forKey: .trackingId)
        try container.encode(bankId, forKey: .bankId)
    }
}
