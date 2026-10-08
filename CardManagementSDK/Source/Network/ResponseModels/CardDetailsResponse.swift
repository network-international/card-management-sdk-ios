//
//  CardDetailsResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 07.10.2022.
//

import Foundation

class CardDetailsResponse {
    private struct ClearInfo {
        let cardNumber: String
        let cvv2: String
    }
    
    private struct CardDetails: Codable {
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
    
    let maskedPan: String?
    let expiryDate: String                      // formatted expiry
    let cardholderName: String?                 /// Embossing name on the card
    let embossingLine4: String?                 /// Fourth line embossing (e.g. company name, loyalty membership number)
    let productCode: String?                    /// Full produce code for the card
    let productShortCode: String?               /// Short code for the product of the card (E.g. 001)
    let productName: String?                    /// Product display name (e.g. VISA Classic)
    let cardBrand: String?                      /// Card Brand (E.g. Visa, MasterCard, etc.). Can be used to provide visual representation of the card
    
    // Decrypted
    let cardNumber: String
    let cvv2: String
    
    init(json: Data, privateKey: SecKey) throws {
        let parsed = try JSONDecoder().decode(CardDetails.self, from: json)
        let clearInfo = try Self.decrypt(privateKey: privateKey, from: parsed)
        
        maskedPan = parsed.maskedPan
        cardholderName = parsed.cardholderName
        embossingLine4 = parsed.embossingLine4
        productCode = parsed.productCode
        productShortCode = parsed.productShortCode
        productName = parsed.productName
        cardBrand = parsed.cardBrand

        expiryDate = Self.formatExpiryDate(
            parsed.expiry // Card Expiry Date YYMM format
        )
        cardNumber = clearInfo.cardNumber
        cvv2 = clearInfo.cvv2
    }
    
}

private extension CardDetailsResponse {
    
    static func formatExpiryDate(_ expiry: String?) -> String {
        guard let expiry = expiry, expiry != "" else { return "-" }
        var value = String(expiry.suffix(2) + expiry.prefix(2))
        let separator: Character = "/"
        let i = value.index(value.startIndex, offsetBy: 2)
        value.insert(separator, at: i)
        return value
    }
    
    private static func decrypt(privateKey: SecKey, from cardDetails: CardDetails) throws -> ClearInfo {
        guard
            let encryptedPan = cardDetails.encryptedPan,
            let encryptedCVV2 = cardDetails.encryptedCVV2
        else { throw RSADecryptError.emptyData }
        let algorithm = GlobalConfig.NIRSAAlgorithm
        let decryptedPan = try RSAUtils.decrypt(cipherText: encryptedPan.hexaData, privateKey: privateKey, algorithm: algorithm)
        let clearPan = decryptedPan.hexStringtoAscii()
        
        let clearCVV2 = try RSAUtils.decrypt(cipherText: encryptedCVV2.hexaData, privateKey: privateKey, algorithm: algorithm)
        return .init(cardNumber: clearPan, cvv2: clearCVV2)
    }
}
