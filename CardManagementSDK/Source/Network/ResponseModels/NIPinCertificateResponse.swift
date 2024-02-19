//
//  NIPinCertificateResponse.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 13.10.2022.
//

import Foundation

class NIPinCertificateResponse {    
    let certificate: String?
    
    init(certificate: String?) {
        self.certificate = certificate
    }
}
