//
//  ViewPinParams.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 28.08.2023.
//

import Foundation

struct ViewPinParams: Codable {
    
    var publicKey: String
    var cardIdentifierId: String
    var cardIdentifierType: String
    
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
        case publicKey = "public_key"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.cardIdentifierId, forKey: .cardIdentifierId)
        try container.encode(self.cardIdentifierType, forKey: .cardIdentifierType)
        try container.encode(self.publicKey, forKey: .publicKey)
    }
}
