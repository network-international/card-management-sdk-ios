//
//  PinCertificateResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 13.10.2022.
//

import Foundation

class PinCertificateResponse: NSObject, Codable {
    
    var certificate: String?
    
    enum CodingKeys: String, CodingKey {
        case certificate = "certificate"
    }
    
    func parse(json: Data) -> PinCertificateResponse? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(PinCertificateResponse.self, from: json)
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
