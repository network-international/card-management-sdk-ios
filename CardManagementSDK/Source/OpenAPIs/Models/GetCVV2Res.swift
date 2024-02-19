//
// GetCVV2Res.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct GetCVV2Res: Codable, JSONEncodable, Hashable {

    internal var responseGetCvv2: ResponseGetCvv2

    internal init(responseGetCvv2: ResponseGetCvv2) {
        self.responseGetCvv2 = responseGetCvv2
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case responseGetCvv2 = "response_get_cvv2"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(responseGetCvv2, forKey: .responseGetCvv2)
    }
}

