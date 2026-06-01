//
//  CardLookupResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 13.10.2022.
//

import Foundation

class CardLookupResponse: NSObject, Codable {
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
    
    func parse(json: Data) -> CardLookupResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(CardLookupResponse.self, from: json)
            return response
        } catch DecodingError.dataCorrupted(let context) {
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }

        return nil
    }
    
}

extension CardLookupResponse {
    
    var cardNumber: String? {
        guard let encryptedCardIdentifierId = cardIdentifierId else { return "" }
        let data = encryptedCardIdentifierId.hexaData
        guard let decryptedValue = RSAUtils.decrypt(cipherText: data, keyTag: GlobalConfig.shared.privateKeychainTag, algorithm: GlobalConfig.NIRSAAlgorithm) else { return nil }
        let clearCardIdentifierId = decryptedValue.hexStringtoAscii()
        return clearCardIdentifierId
    }
    
}
