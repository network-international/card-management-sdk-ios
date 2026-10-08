//
//  CardDetailsParams.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 12.10.2022.
//

import Foundation

struct CardDetailsParams: Codable {
    
    var publicKey: String
    
    func toJson() -> [String: Any] {
        let encoder = JSONEncoder()
        do {
            let json = try encoder.encode(self)
            let dict = try JSONSerialization.jsonObject(with: json, options: []) as! [String : Any]
            return dict
        } catch {
            return [:]
        }
    }
    
}
