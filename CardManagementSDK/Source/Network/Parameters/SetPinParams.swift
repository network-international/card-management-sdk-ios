//
//  SetPinParams.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 19.10.2022.
//

import Foundation

struct SetPinParams: Codable {
    
    var cardIdentifierId: String
    var cardIdentifierType: String
//    var cardSequenceNumber: String?
//    var cardExpiryDate: String?
    var encryptedPin: String
    var encryptionMethod: String
//    var encryptionAlgorithm: String
    
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
//        case cardSequenceNumber = "card_sequence_number"
//        case cardExpiryDate = "card_expiry_date"
        case encryptedPin = "encrypted_pin"
        case encryptionMethod = "encryption_method"
//        case encryptionAlgorithm = "encryption_algorithm"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.cardIdentifierId, forKey: .cardIdentifierId)
        try container.encode(self.cardIdentifierType, forKey: .cardIdentifierType)
//        try container.encode(self.cardSequenceNumber, forKey: .cardSequenceNumber)
//        try container.encode(self.cardExpiryDate, forKey: .cardExpiryDate)
        try container.encode(self.encryptedPin, forKey: .encryptedPin)
        try container.encode(self.encryptionMethod, forKey: .encryptionMethod)
//        try container.encode(self.encryptionAlgorithm, forKey: .encryptionAlgorithm)
    }
    
}
