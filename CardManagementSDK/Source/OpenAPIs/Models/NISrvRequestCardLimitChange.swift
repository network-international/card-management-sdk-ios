//
// NISrvRequestCardLimitChange.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct NISrvRequestCardLimitChange: Codable, JSONEncodable, Hashable {

    internal var nISrvRequest: CardLimitChangeReq

    internal init(nISrvRequest: CardLimitChangeReq) {
        self.nISrvRequest = nISrvRequest
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case nISrvRequest = "NISrvRequest"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nISrvRequest, forKey: .nISrvRequest)
    }
}
