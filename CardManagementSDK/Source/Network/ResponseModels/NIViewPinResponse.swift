//
//  NIViewPinResponse.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 29.08.2023.
//

import Foundation

class NIViewPinResponse: NSObject, Codable {
    private struct ClearInfo {
        let pin: String
    }
    
    let pin: String
    
    init(encryptedPin: String?, privateKey: SecKey) throws {
        pin = try Self.decrypt(privateKey: privateKey, encryptedPin: encryptedPin).pin
    }
    
    private static func decrypt(privateKey: SecKey, encryptedPin: String?) throws -> ClearInfo {
        guard
            let encryptedPin = encryptedPin
        else { throw RSADecryptError.emptyData }
        let algorithm = GlobalConfig.NIRSAAlgorithm
        let decryptedValue = try RSAUtils.decrypt(cipherText: encryptedPin.hexaData, privateKey: privateKey, algorithm: algorithm)
        return .init(pin: decryptedValue)
    }
}
