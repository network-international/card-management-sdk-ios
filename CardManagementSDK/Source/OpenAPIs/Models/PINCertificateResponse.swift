//
// PINCertificateResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct PINCertificateResponse: Codable, JSONEncodable, Hashable {

    /** X.509 Certificate  */
    internal var certificate: String?

    internal init(certificate: String? = nil) {
        self.certificate = certificate
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case certificate
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(certificate, forKey: .certificate)
    }
}
