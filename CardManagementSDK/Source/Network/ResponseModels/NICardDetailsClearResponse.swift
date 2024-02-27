//
//  NICardDetailsClearResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 07.10.2022.
//

import Foundation

class NICardDetailsClearResponse {
    private struct ClearInfo {
        let cardNumber: String
        let cvv2: String
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
    
    init(secured: CardDetailsSecuredResponse, privateKey: SecKey) throws {
        let clearInfo = try Self.decrypt(privateKey: privateKey, encryptedPan: secured.encryptedPan, encryptedCVV2: secured.encryptedCvv2)
        maskedPan = secured.maskedPan
        cardholderName = secured.cardholderName
        embossingLine4 = secured.embossingLine4
        productCode = secured.productCode
        productShortCode = secured.productShortCode
        productName = secured.productName
        cardBrand = secured.cardBrand

        expiryDate = Self.formatExpiryDate(
            secured.expiry // Card Expiry Date YYMM format
        )
        cardNumber = clearInfo.cardNumber
        cvv2 = clearInfo.cvv2
    }
}

private extension NICardDetailsClearResponse {
    
    static func formatExpiryDate(_ expiry: String?) -> String {
        guard let expiry = expiry, expiry != "" else { return "-" }
        var value = String(expiry.suffix(2) + expiry.prefix(2))
        let separator: Character = "/"
        let i = value.index(value.startIndex, offsetBy: 2)
        value.insert(separator, at: i)
        return value
    }
    
    private static func decrypt(privateKey: SecKey, encryptedPan: String?, encryptedCVV2: String?) throws -> ClearInfo {
        guard
            let encryptedPan = encryptedPan,
            let encryptedCVV2 = encryptedCVV2
        else { throw RSADecryptError.emptyData }
        let algorithm = GlobalConfig.NIRSAAlgorithm
        let decryptedPan = try RSAUtils.decrypt(cipherText: encryptedPan.hexaData, privateKey: privateKey, algorithm: algorithm)
        let clearPan = decryptedPan.hexStringtoAscii()
        
        let clearCVV2 = try RSAUtils.decrypt(cipherText: encryptedCVV2.hexaData, privateKey: privateKey, algorithm: algorithm)
        return .init(cardNumber: clearPan, cvv2: clearCVV2)
    }
}
