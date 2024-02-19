//
// TariffDetailsRes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct TariffDetailsRes: Codable, JSONEncodable, Hashable {

    internal var responseTariffDetails: ResponseTariffDetails

    internal init(responseTariffDetails: ResponseTariffDetails) {
        self.responseTariffDetails = responseTariffDetails
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case responseTariffDetails = "response_tariff_details"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(responseTariffDetails, forKey: .responseTariffDetails)
    }
}

