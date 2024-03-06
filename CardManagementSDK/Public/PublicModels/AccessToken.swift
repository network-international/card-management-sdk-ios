//
//  AccessToken.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 18.12.2023.
//

import Foundation

public struct AccessToken: Codable {
    public let value: String
    public let type: String?
    public let expiresIn: TimeInterval
    public let created: TimeInterval
    
    public init(value: String, type: String? = nil, expiresIn: TimeInterval, created: TimeInterval = Date().timeIntervalSince1970) {
        self.value = value
        self.type = type
        self.expiresIn = expiresIn
        self.created = created
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case type = "token_type"
        case expiresIn = "expires_in"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decode(String.self, forKey: .accessToken)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        if let expiresIn = try? values.decodeIfPresent(TimeInterval.self, forKey: .expiresIn) {
            self.expiresIn = expiresIn
        } else {
            expiresIn = 1800
        }
        created = Date().timeIntervalSince1970
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .accessToken)
        if let type = type {
            try container.encode(type, forKey: .type)
        }
        try container.encode(expiresIn, forKey: .expiresIn)
    }
}

extension AccessToken {
    var isExpired: Bool {
        (Date().timeIntervalSince1970 - created) > expiresIn
    }
}


