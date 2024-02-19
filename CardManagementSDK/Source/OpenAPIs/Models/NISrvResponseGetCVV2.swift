//
// NISrvResponseGetCVV2.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct NISrvResponseGetCVV2: Codable, JSONEncodable, Hashable {

    internal var nISrvResponse: GetCVV2Res

    internal init(nISrvResponse: GetCVV2Res) {
        self.nISrvResponse = nISrvResponse
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case nISrvResponse = "NISrvResponse"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nISrvResponse, forKey: .nISrvResponse)
    }
}

