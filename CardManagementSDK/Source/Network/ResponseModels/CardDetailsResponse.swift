//
//  CardDetailsResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 07.10.2022.
//

import Foundation

class CardDetailsResponse: NSObject, Codable {
    
    var encryptedPan: String?                   /// Encrypted PAN under the provided public key
    var maskedPan: String?
    var expiry: String?                         /// Card Expiry Date YYMM format
    var encryptedCVV2: String?                  /// CVV2 Encrypted under the provided public key
    var cardholderName: String?                 /// Embossing name on the card
    var embossingLine4: String?                 /// Fourth line embossing (e.g. company name, loyalty membership number)
    var productCode: String?                    /// Full produce code for the card
    var productShortCode: String?               /// Short code for the product of the card (E.g. 001)
    var productName: String?                    /// Product display name (e.g. VISA Classic)
    var cardBrand: String?                      /// Card Brand (E.g. Visa, MasterCard, etc.). Can be used to provide visual representation of the card
    
    enum CodingKeys: String, CodingKey {
        case encryptedPan = "encrypted_pan"
        case maskedPan = "masked_pan"
        case expiry = "expiry"
        case encryptedCVV2 = "encrypted_cvv2"
        case cardholderName = "cardholder_name"
        case embossingLine4 = "embossing_line4"
        case productCode = "product_code"
        case productShortCode = "product_short_code"
        case productName = "product_name"
        case cardBrand = "card_brand"
    }
    
    func parse(json: Data) -> CardDetailsResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(CardDetailsResponse.self, from: json)
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
//            print("error: ", error)
        }
        
        return nil
    }
}

extension CardDetailsResponse {
    
    var cardNumber: String {
        guard let encryptedPan = encryptedPan else { return "" }
        let data = encryptedPan.hexaData
        guard let decryptedValue = RSAUtils.decrypt(cipherText: data, keyTag: GlobalConfig.shared.privateKeychainTag, algorithm: GlobalConfig.NIRSAAlgorithm) else { return "" }
        let clearPan = decryptedValue.hexStringtoAscii()
        return clearPan
    }
    
    var expiryDate: String {
        guard let expiry = expiry else { return "-" }
        var value = expiry
        let separator: Character = "/"
        let i = value.index(value.startIndex, offsetBy: 2)
        value.insert(separator, at: i)
        return value
    }
    
    var cvv2: String {
        guard let encryptedCVV2 = encryptedCVV2 else { return "" }
        let data = encryptedCVV2.hexaData
        let clearCVV2 = RSAUtils.decrypt(cipherText: data, keyTag: GlobalConfig.shared.privateKeychainTag, algorithm: GlobalConfig.NIRSAAlgorithm)
        return clearCVV2 ?? ""
    }
    
    var holderName: String {
        return cardholderName ?? ""
    }
    
}
