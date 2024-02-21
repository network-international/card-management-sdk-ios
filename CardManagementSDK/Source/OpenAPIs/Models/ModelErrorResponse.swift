//
// ModelErrorResponse.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

internal struct ModelErrorResponse: Codable, JSONEncodable, Hashable {

    internal var errorCode: String?
    internal var errorDescription: String?
    internal var stackTrace: String?

    internal init(errorCode: String? = nil, errorDescription: String? = nil, stackTrace: String? = nil) {
        self.errorCode = errorCode
        self.errorDescription = errorDescription
        self.stackTrace = stackTrace
    }

    internal enum CodingKeys: String, CodingKey, CaseIterable {
        case errorCode = "error_code"
        case errorDescription = "error_description"
        case stackTrace = "stack_trace"
    }

    // Encodable protocol methods

    internal func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(errorCode, forKey: .errorCode)
        try container.encodeIfPresent(errorDescription, forKey: .errorDescription)
        try container.encodeIfPresent(stackTrace, forKey: .stackTrace)
    }
}
