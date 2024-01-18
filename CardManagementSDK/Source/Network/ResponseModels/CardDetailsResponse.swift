//
//  CardDetailsResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 07.10.2022.
//

import Foundation

class CardDetailsResponse {
    private struct CardDetails: Codable {
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
    }
    
    private let privateKeychainTag: String?
    let encryptedPan: String?                   /// Encrypted PAN under the provided public key
    let maskedPan: String?
    let expiry: String?                         /// Card Expiry Date YYMM format
    let encryptedCVV2: String?                  /// CVV2 Encrypted under the provided public key
    let cardholderName: String?                 /// Embossing name on the card
    let embossingLine4: String?                 /// Fourth line embossing (e.g. company name, loyalty membership number)
    let productCode: String?                    /// Full produce code for the card
    let productShortCode: String?               /// Short code for the product of the card (E.g. 001)
    let productName: String?                    /// Product display name (e.g. VISA Classic)
    let cardBrand: String?                      /// Card Brand (E.g. Visa, MasterCard, etc.). Can be used to provide visual representation of the card
    
    init?(json: Data, privateKeychainTag: String?) {
        guard let parsed = try? JSONDecoder().decode(CardDetails.self, from: json) else {
            return nil
        }
        self.privateKeychainTag = privateKeychainTag
        
        encryptedPan = parsed.encryptedPan
        maskedPan = parsed.maskedPan
        expiry = parsed.expiry
        encryptedCVV2 = parsed.encryptedCVV2
        cardholderName = parsed.cardholderName
        embossingLine4 = parsed.embossingLine4
        productCode = parsed.productCode
        productShortCode = parsed.productShortCode
        productName = parsed.productName
        cardBrand = parsed.cardBrand
    }
}

extension CardDetailsResponse {
    
    var cardNumber: String? {
        guard let encryptedPan = encryptedPan else { return nil }
        let data = encryptedPan.hexaData
        guard let decryptedValue = RSAUtils.decrypt(cipherText: data, keyTag: privateKeychainTag, algorithm: GlobalConfig.NIRSAAlgorithm) else { return nil }
        let clearPan = decryptedValue.hexStringtoAscii()
        return clearPan
    }
    
    var expiryDate: String {
        guard let expiry = expiry, expiry != "" else { return "-" }
        var value = String(expiry.suffix(2) + expiry.prefix(2))
        let separator: Character = "/"
        let i = value.index(value.startIndex, offsetBy: 2)
        value.insert(separator, at: i)
        return value
    }
    
    var cvv2: String? {
        guard let encryptedCVV2 = encryptedCVV2 else { return nil }
        let data = encryptedCVV2.hexaData
        let clearCVV2 = RSAUtils.decrypt(cipherText: data, keyTag: privateKeychainTag, algorithm: GlobalConfig.NIRSAAlgorithm)
        return clearCVV2
    }
    
    var holderName: String? {
        return cardholderName
    }
    
}
