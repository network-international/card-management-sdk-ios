//
// Copyright (c) 2016 Stefan van den Oord. All rights reserved.

import Foundation
import Security

public struct KeyPair {
    public let privateKey: SecKey
    public let publicKey: SecKey
}

extension SecKey {

    /**
     * Generates an RSA private-public key pair. Wraps `SecKeyGeneratePair()`.
     *
     * - parameter ofSize: the size of the keys in bits
     * - parameter tag: "com.example.keys.mykey".data(using: .utf8)!
     * - parameter isPermanent: if it should be stored in keychain
     * - returns: The generated key pair.
     * - throws: A `SecKeyError` when something went wrong.
     */
    public static func generateKeyPair(ofSize bits:UInt, tag: Data, isPermanent: Bool) throws -> KeyPair {
        
        let attributes: NSDictionary = [
            kSecAttrKeyType as String : kSecAttrKeyTypeRSA as String,
            // def is 4096, but: RSA keys may have key size values of 512, 768, 1024, or 2048.
            // TLS server certificates and issuing CAs using RSA keys must use key sizes greater than or equal to 2048 bits. Certificates using RSA key sizes smaller than 2048 bits are no longer trusted for TLS.
            kSecAttrKeySizeInBits as String : bits,
            // it’s typically easier to store only the private key and then generate the public key from it when needed.
            // That way you don’t need to keep track of another tag or clutter your keychain.
            // kSecPublicKeyAttrs as String : [ kSecAttrIsPermanent as String: true ],
            kSecPrivateKeyAttrs as String : [
                kSecAttrIsPermanent as String: isPermanent,
                kSecAttrApplicationTag as String: tag
            ]
        ]
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes, &error) else {
            throw KeychainError.generateKeyFailed(error: error!.takeRetainedValue() as Error)
        }
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            // public key is not available for specified key.
            throw KeychainError.publicKeyNotAvailable
        }
        return .init(privateKey: privateKey, publicKey: publicKey)
    }
}
