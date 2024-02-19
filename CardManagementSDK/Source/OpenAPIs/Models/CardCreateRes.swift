//
// CardCreateRes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CardCreateRes: Codable, JSONEncodable, Hashable {

    internal var responseCardCreate: ResponseCardCreate

    internal init(responseCardCreate: ResponseCardCreate) {
        self.responseCardCreate = responseCardCreate
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case responseCardCreate = "response_card_create"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(responseCardCreate, forKey: .responseCardCreate)
    }
}

