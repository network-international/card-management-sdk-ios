//
//  ViewPinResponse.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 29.08.2023.
//

import Foundation

class ViewPinResponse: NSObject, Codable {
    private struct ViewPin: Codable {
        var encryptedPin: String?                   /// Encrypted PIN under the provided public key
     
        enum CodingKeys: String, CodingKey {
            case encryptedPin = "encrypted_pin"
        }
    }
    
    let encryptedPin: String?
    private let privateKeychainTag: String?
    
    init?(json: Data, privateKeychainTag: String?) {
        guard let viewpin = try? JSONDecoder().decode(ViewPin.self, from: json) else { return nil }
        encryptedPin = viewpin.encryptedPin
        self.privateKeychainTag = privateKeychainTag
    }
}

extension ViewPinResponse {
    
    var pin: String? {
        guard let encryptedPin = encryptedPin else { return nil }
        let data = encryptedPin.hexaData
        guard let decryptedValue = RSAUtils.decrypt(cipherText: data, keyTag: privateKeychainTag, algorithm: GlobalConfig.NIRSAAlgorithm) else { return nil }
        return decryptedValue
    }
}
