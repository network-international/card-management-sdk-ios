//
// GetPlanListRes.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct GetPlanListRes: Codable, JSONEncodable, Hashable {

    internal var responseGetPlanList: ResponseGetPlanList

    internal init(responseGetPlanList: ResponseGetPlanList) {
        self.responseGetPlanList = responseGetPlanList
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case responseGetPlanList = "response_get_plan_list"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(responseGetPlanList, forKey: .responseGetPlanList)
    }
}
