//
//  ViewPinResponse.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 29.08.2023.
//

import Foundation

class ViewPinResponse: NSObject, Codable {
    
    var encryptedPin: String?                   /// Encrypted PIN under the provided public key
 
    enum CodingKeys: String, CodingKey {
        case encryptedPin = "encrypted_pin"
    }
    
    func parse(json: Data) -> ViewPinResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(ViewPinResponse.self, from: json)
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

extension ViewPinResponse {
    
    var pin: String {
        guard let encryptedPin = encryptedPin else { return "" }
        let data = encryptedPin.hexaData
        guard let decryptedValue = RSAUtils.decrypt(cipherText: data, keyTag: GlobalConfig.shared.privateKeychainTag, algorithm: GlobalConfig.NIRSAAlgorithm) else { return "" }
        return decryptedValue
    }
}
