//
// CustomFieldsCardReplacement.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CustomFieldsCardReplacement: Codable, JSONEncodable, Hashable {

    static let keyRule = StringRule(minLength: 1, maxLength: 32, pattern: nil)
    static let valueRule = StringRule(minLength: 1, maxLength: 128, pattern: nil)
    /** Custom Tag */
    internal var key: String?
    /** Tag value */
    internal var value: String?

    internal init(key: String? = nil, value: String? = nil) {
        self.key = key
        self.value = value
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case key
        case value
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(key, forKey: .key)
        try container.encodeIfPresent(value, forKey: .value)
    }
}
