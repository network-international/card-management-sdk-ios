//
//  PinEncryption.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 20.10.2022.
//

import Foundation

struct PinEncryption {
    let pin: String
    let pan: String
    let certificate: String
    
    let encryptedPinBlock: String
    
    let method: String = "ASYMMETRIC_ENC"
    let algorithm: String = ""  // TODO: will be a constant value; IT IS NOT USED YET IN THE API - no need to send it in the request body
    
    init(pin: String, pan: String, certificate: String) throws {
        self.pin = pin
        self.pan = pan
        self.certificate = certificate
        
        /// Create  pin block
        let pinBlock = PinBlock.createPinBlock(pin, pan)
        /// Encrypt pin block
        encryptedPinBlock = try Self.encryptPin(pinBlock, certificate: certificate)
    }
    
    /// Create & encrypt pin block
    private static func encryptPin(_ pinBlock: String, certificate: String) throws -> String {
        let encryptedPinBlock = try RSAUtils.encrypt(string: pinBlock, certificate: certificate)
        return encryptedPinBlock
    }
    
}
