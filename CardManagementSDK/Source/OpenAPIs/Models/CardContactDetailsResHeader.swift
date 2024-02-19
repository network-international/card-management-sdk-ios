//
// CardContactDetailsResHeader.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardContactDetailsResHeader: Codable, JSONEncodable, Hashable {

    static let msgIdRule = StringRule(minLength: 1, maxLength: 12, pattern: nil)
    static let msgTypeRule = StringRule(minLength: 1, maxLength: 12, pattern: nil)
    static let msgFunctionRule = StringRule(minLength: 1, maxLength: 50, pattern: nil)
    static let srcApplicationRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    static let targetApplicationRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    static let timestampRule = StringRule(minLength: 1, maxLength: 30, pattern: nil)
    static let bankIdRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    /** The msg_id sent in the request will be sent back in response in this field */
    internal var msgId: String
    /** Message Type – This can have either “TRANSACTION” or “ENQUIRY”    As for this API the value expected is “ENQUIRY”  */
    internal var msgType: String
    /** Static Value -  REP_CARD_CONTACT_DETAILS */
    internal var msgFunction: String
    /** Source Application: This is a free Text and the client can populate the source system from where the API is Initiated    Example: IVR, IB, MB    No Validations of these are kept at Network Systems */
    internal var srcApplication: String
    /** The target_application can hold any value from FI side, this can be used by FI to check the target system of the API call */
    internal var targetApplication: String
    /** Timestamp of the request - Format  YYYY-MM-DDtHH:MM:SS.SSS+04:00 */
    internal var timestamp: String
    /** Bank code is Unique Id 3 digit number for each client and the same will be provided once the client setup is completed in our core system.    For sandbox testing – “982” is used */
    internal var bankId: String

    internal init(msgId: String, msgType: String, msgFunction: String, srcApplication: String, targetApplication: String, timestamp: String, bankId: String) {
        self.msgId = msgId
        self.msgType = msgType
        self.msgFunction = msgFunction
        self.srcApplication = srcApplication
        self.targetApplication = targetApplication
        self.timestamp = timestamp
        self.bankId = bankId
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case msgId = "msg_id"
        case msgType = "msg_type"
        case msgFunction = "msg_function"
        case srcApplication = "src_application"
        case targetApplication = "target_application"
        case timestamp
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
        try container.encode(bankId, forKey: .bankId)
    }
}

