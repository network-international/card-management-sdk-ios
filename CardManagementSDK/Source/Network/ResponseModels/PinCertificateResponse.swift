//
//  PinCertificateResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 13.10.2022.
//

import Foundation

class PinCertificateResponse {
    private struct PinCertificate: Codable {
        let certificate: String?
        
        enum CodingKeys: String, CodingKey {
            case certificate = "certificate"
        }
    }
    
    let certificate: String?
    
    init(json: Data) throws {
        let response = try JSONDecoder().decode(PinCertificate.self, from: json)
        certificate = response.certificate
    }
    
}
