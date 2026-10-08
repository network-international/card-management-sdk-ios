//
//  CardLookupParams.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 13.10.2022.
//

import Foundation

struct CardLookupParams: Codable {
    
    var cardIdentifierId: String
    var cardIdentifierType: String
    var publicKey: String
    
    func toJson() -> [String: Any] {
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(self)
            let dict = try JSONSerialization.jsonObject(with: json, options: []) as! [String : Any]
            return dict
        } catch {
            return [:]
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case cardIdentifierId = "card_identifier_id"
        case cardIdentifierType = "card_identifier_type"
        case publicKey = "publicKey"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.cardIdentifierId, forKey: .cardIdentifierId)
        try container.encode(self.cardIdentifierType, forKey: .cardIdentifierType)
        try container.encode(self.publicKey, forKey: .publicKey)
    }
    
}
