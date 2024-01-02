//
//  CardLookupResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 13.10.2022.
//

import Foundation

class CardLookupResponse {
    private struct CardLookup: Codable {
        ///Card Identifier Type:
        /// - EXID - External Id
        /// - CONTRACT_NUMBER - Clear PAN
        var cardIdentifierId: String?
        
        /// Identifier related to the Identifier Type
        var cardIdentifierType: String?
        
        
        enum CodingKeys: String, CodingKey {
            case cardIdentifierId = "card_identifier_id"
            case cardIdentifierType = "card_identifier_type"
        }
    }
    
    ///Card Identifier Type:
    /// - EXID - External Id
    /// - CONTRACT_NUMBER - Clear PAN
    let cardIdentifierId: String?
    
    /// Identifier related to the Identifier Type
    let cardIdentifierType: String?
    
    private let privateKeychainTag: String?
    
    init?(json: Data, privateKeychainTag: String?) {
        guard let parsed = try? JSONDecoder().decode(CardLookup.self, from: json) else { return nil }
        cardIdentifierId = parsed.cardIdentifierId
        cardIdentifierType = parsed.cardIdentifierType
        self.privateKeychainTag = privateKeychainTag
    }
    
}

extension CardLookupResponse {
    
    var cardNumber: String? {
        guard let encryptedCardIdentifierId = cardIdentifierId else { return nil }
        let data = encryptedCardIdentifierId.hexaData
        guard let decryptedValue = RSAUtils.decrypt(cipherText: data, keyTag: privateKeychainTag, algorithm: GlobalConfig.NIRSAAlgorithm) else {
            return nil
        }
        let clearCardIdentifierId = decryptedValue.hexStringtoAscii()
        return clearCardIdentifierId
    }
    
}
