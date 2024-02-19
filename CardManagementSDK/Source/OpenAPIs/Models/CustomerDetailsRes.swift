//
// CustomerDetailsRes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CustomerDetailsRes: Codable, JSONEncodable, Hashable {

    internal var responseGenericCustomerDetails: ResponseGenericCustomerDetails

    internal init(responseGenericCustomerDetails: ResponseGenericCustomerDetails) {
        self.responseGenericCustomerDetails = responseGenericCustomerDetails
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case responseGenericCustomerDetails = "response_generic_customer_details"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(responseGenericCustomerDetails, forKey: .responseGenericCustomerDetails)
    }
}

