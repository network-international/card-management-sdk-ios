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
    
    public init(value: String, type: String? = nil, expiresIn: TimeInterval) {
        self.value = value
        self.type = type
        self.expiresIn = expiresIn
        self.created = Date().timeIntervalSince1970
    }
    /**
     {
                   "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJrUV9BVG96UWc5cjRvOWw3QzJKVFRKU0FOUlV2U2JiTDNUcTRTeUh6T29RIn0.eyJleHAiOjE3MDI0Nzc3OTgsImlhdCI6MTcwMjQ3NTk5OCwianRpIjoiMTNhMDI4YjktNGRjYy00ODY1LWEzNDQtZTE2MTBhYzdjNmFjIiwiaXNzIjoiaHR0cHM6Ly9pZGVudGl0eS1ub25wcm9kLm5ldHdvcmsuc2EvYXV0aC9yZWFsbXMvTkktTm9uUHJvZCIsInN1YiI6ImVlYmNiZGZiLTc3MDEtNDljMS1iYWVjLTcwZjYyYjU4ZWFiZSIsInR5cCI6IkJlYXJlciIsImF6cCI6ImZhMGI1YTYzLTcyMjItNGU4Mi1hMDQ3LTQ3ZTJlZjY2NTdlZjMxIiwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJjbGllbnRJZCI6ImZhMGI1YTYzLTcyMjItNGU4Mi1hMDQ3LTQ3ZTJlZjY2NTdlZjMxIiwib3JnX2lkIjoiQ1JPQVQiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJzZXJ2aWNlLWFjY291bnQtZmEwYjVhNjMtNzIyMi00ZTgyLWEwNDctNDdlMmVmNjY1N2VmMzEifQ.OTRLdaKzNU5n_G_1OlcsVic7cBQXgUgbZZG7qHupc5Y70VXAwPGoqAZ8Rnn6T4fgLfJJPYeyjcKxMJ8PWnWPK9OoCKmBCIONIZhFLzeiFD4xU5DeXQnxpc7hBkgCcuLUs0P6XhU4qb71hYISNLFgaqrzjh23ax30yAx-XsbrcG0nckx_jsvLG533qX5l2IJJg2dN2SSC1KaDM0h8bbtxS6WJ3lMekG_gBvqLt9RCGOKIdXZOnlZVJimWPH1EtaRbhd_3TuEWqKpepTWLM8v6Ie07adBUiPCCJrDaPDtLFv-GCqRFBd3WBkI8ffJVbuQooHn11IQB5TP-9bA0vjlNPw",
                   "token_type": "Bearer",
                   "expires_in" : "1800"
                   }
     */
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


