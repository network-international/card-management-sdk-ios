//
// CustomerDetailsReq.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct CustomerDetailsReq: Codable, JSONEncodable, Hashable {

    internal var requestGenericCustomerDetails: RequestGenericCustomerDetails

    internal init(requestGenericCustomerDetails: RequestGenericCustomerDetails) {
        self.requestGenericCustomerDetails = requestGenericCustomerDetails
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case requestGenericCustomerDetails = "request_generic_customer_details"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestGenericCustomerDetails, forKey: .requestGenericCustomerDetails)
    }
}
