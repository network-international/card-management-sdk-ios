//
//  NICardLookupResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 13.10.2022.
//

import Foundation

class NICardLookupResponse {
    private struct ClearInfo {
        let cardNumber: String
    }
    
    let cardNumber: String
    
    init(encryptedCardIdentifier: String?, privateKey: SecKey) throws {
        cardNumber = try Self.decrypt(privateKey: privateKey, encryptedCardIdentifier: encryptedCardIdentifier).cardNumber
    }
    
    private static func decrypt(privateKey: SecKey, encryptedCardIdentifier: String?) throws -> ClearInfo {
        guard
            let encryptedCardIdentifierId = encryptedCardIdentifier
        else { throw RSADecryptError.emptyData }
        let algorithm = GlobalConfig.NIRSAAlgorithm
        let decryptedValue = try RSAUtils.decrypt(cipherText: encryptedCardIdentifierId.hexaData, privateKey: privateKey, algorithm: algorithm)
        return .init(cardNumber: decryptedValue.hexStringtoAscii())
    }
}
