//
// GetListOfAccountsResHeader.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct GetListOfAccountsResHeader: Codable, JSONEncodable, Hashable {

    static let msgIdRule = StringRule(minLength: 1, maxLength: 12, pattern: nil)
    static let msgTypeRule = StringRule(minLength: 1, maxLength: 12, pattern: nil)
    static let msgFunctionRule = StringRule(minLength: 1, maxLength: 50, pattern: nil)
    static let srcApplicationRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    static let trackingIdRule = StringRule(minLength: 1, maxLength: 15, pattern: nil)
    static let bankIdRule = StringRule(minLength: 1, maxLength: 4, pattern: nil)
    static let instanceIdRule = StringRule(minLength: 1, maxLength: 10, pattern: nil)
    /** Unique Source Message ID eg ada123456fdsf */
    internal var msgId: String
    /** Message Type – This can have either “TRANSACTION” or “ENQUIRY”    As for this API the value expected is “ENQUIRY”  */
    internal var msgType: String
    /** Message functions: Should be  “REP_LIST_OF_ACCOUNTS”  */
    internal var msgFunction: String
    /** Source Application: This is a free Text and the client can populate the source system from where the API is Initiated    Example: IVR, IB, MB    No Validations of these are kept at Network Systems */
    internal var srcApplication: String
    /** Transaction Tracking Id */
    internal var trackingId: String?
    /** Bank Id is Unique Id 4 digit code for each client and the same will be provided once the client setup is completed in our core system.    For sandbox testing – Please use “NIC”  */
    internal var bankId: String
    /** instance_id */
    internal var instanceId: String?

    internal init(msgId: String, msgType: String, msgFunction: String, srcApplication: String, trackingId: String? = nil, bankId: String, instanceId: String? = nil) {
        self.msgId = msgId
        self.msgType = msgType
        self.msgFunction = msgFunction
        self.srcApplication = srcApplication
        self.trackingId = trackingId
        self.bankId = bankId
        self.instanceId = instanceId
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case msgId = "msg_id"
        case msgType = "msg_type"
        case msgFunction = "msg_function"
        case srcApplication = "src_application"
        case trackingId = "tracking_id"
        case bankId = "bank_id"
        case instanceId = "instance_id"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(msgId, forKey: .msgId)
        try container.encode(msgType, forKey: .msgType)
        try container.encode(msgFunction, forKey: .msgFunction)
        try container.encode(srcApplication, forKey: .srcApplication)
        try container.encodeIfPresent(trackingId, forKey: .trackingId)
        try container.encode(bankId, forKey: .bankId)
        try container.encodeIfPresent(instanceId, forKey: .instanceId)
    }
}

