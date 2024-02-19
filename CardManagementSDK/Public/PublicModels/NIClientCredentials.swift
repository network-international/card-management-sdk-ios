//
//  NIClientCredentials.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 20.12.2023.
//

import Foundation

public struct NIClientCredentials: Codable {
    let clientId: String
    let clientSecret: String
    public init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}
