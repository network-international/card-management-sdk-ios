//
// GetPlanListReq.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct GetPlanListReq: Codable, JSONEncodable, Hashable {

    internal var requestGetPlanList: RequestGetPlanList

    internal init(requestGetPlanList: RequestGetPlanList) {
        self.requestGetPlanList = requestGetPlanList
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case requestGetPlanList = "request_get_plan_list"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestGetPlanList, forKey: .requestGetPlanList)
    }
}
