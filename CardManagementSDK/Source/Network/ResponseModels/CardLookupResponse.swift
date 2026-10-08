//
//  CardLookupResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 13.10.2022.
//

import Foundation

class CardLookupResponse {
    private struct ClearInfo {
        let cardNumber: String
    }
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
    
    let cardNumber: String
    private let cardIdentifierType: String?
    
    init(json: Data, privateKey: SecKey) throws {
        let parsed = try JSONDecoder().decode(CardLookup.self, from: json)
        cardNumber = try Self.decrypt(privateKey: privateKey, from: parsed).cardNumber
        cardIdentifierType = parsed.cardIdentifierType
    }
    
    private static func decrypt(privateKey: SecKey, from cardLookup: CardLookup) throws -> ClearInfo {
        guard
            let encryptedCardIdentifierId = cardLookup.cardIdentifierId
        else { throw RSADecryptError.emptyData }
        let algorithm = GlobalConfig.NIRSAAlgorithm
        let decryptedValue = try RSAUtils.decrypt(cipherText: encryptedCardIdentifierId.hexaData, privateKey: privateKey, algorithm: algorithm)
        return .init(cardNumber: decryptedValue.hexStringtoAscii())
    }
}
