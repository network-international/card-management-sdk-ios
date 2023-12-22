//
//  Environment.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 18.12.2023.
//

import Foundation

struct Environment {
    struct Credentials {
        let tokenUrl: URL
        let clientSecret: String
        let clientId: String
    }
    
    let credentials: Credentials
}
