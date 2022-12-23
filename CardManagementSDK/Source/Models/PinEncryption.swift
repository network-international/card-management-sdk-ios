//
//  PinEncryption.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 20.10.2022.
//

import Foundation

struct PinEncryption {
    var pin: String
    var pan: String
    var certificate: String
    
    var encryptedPinBlock: String? {
        /// Create  pin block
        let pinBlock = PinBlock.createPinBlock(pin, pan)
        /// Encrypt pin block
        let encrypted = encryptPin(pinBlock, certificate: certificate)
        return encrypted
    }
    
    let method: String = "ASYMMETRIC_ENC"
    let algorithm: String = ""  // TODO: will be a constant value; IT IS NOT USED YET IN THE API - no need to send it in the request body
    
    init(pin: String, pan: String, certificate: String) {
        self.pin = pin
        self.pan = pan
        self.certificate = certificate
    }
    
    /// Create & encrypt pin block
    private func encryptPin(_ pinBlock: String, certificate: String) -> String? {
        let encryptedPinBlock = RSAUtils.encrypt(string: pinBlock, certificate: certificate)
        return encryptedPinBlock
    }
    
}
