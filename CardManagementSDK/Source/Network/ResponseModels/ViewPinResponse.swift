//
//  ViewPinResponse.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 29.08.2023.
//

import Foundation

class ViewPinResponse: NSObject, Codable {
    private struct ClearInfo {
        let pin: String
    }
    
    private struct ViewPin: Codable {
        let encryptedPin: String?                   /// Encrypted PIN under the provided public key
     
        enum CodingKeys: String, CodingKey {
            case encryptedPin = "encrypted_pin"
        }
    }
    
    let pin: String
    
    init(json: Data, privateKey: SecKey) throws {
        let viewpin = try JSONDecoder().decode(ViewPin.self, from: json)
        pin = try Self.decrypt(privateKey: privateKey, from: viewpin).pin
    }
    
    private static func decrypt(privateKey: SecKey, from viewpin: ViewPin) throws -> ClearInfo {
        guard
            let encryptedPin = viewpin.encryptedPin
        else { throw RSACryptoError.emptyData }
        let algorithm = GlobalConfig.NIRSAAlgorithm
        let decryptedValue = try RSAUtils.decrypt(cipherText: encryptedPin.hexaData, privateKey: privateKey, algorithm: algorithm)
        return .init(pin: decryptedValue)
    }
}
