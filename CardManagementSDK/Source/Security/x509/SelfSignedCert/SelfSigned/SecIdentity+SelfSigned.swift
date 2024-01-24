//
//  Copyright © 2016 Stefan van den Oord. All rights reserved.

import Foundation
import Security


public enum KeychainError: Error {
    /**
     * Indicates that generating a key pair has failed. The associated osStatus is the return value
     * of `SecKeyGeneratePair`.
     *
     * - parameter status: The return value of SecKeyGeneratePair. If this is `errSecSuccess`
     *                       then something else failed.
     */
    case unhandledError(status: OSStatus?)
    // public key is not available for specified key.
    case publicKeyNotAvailable
    // See "Security Error Codes" (SecBase.h).
    case generateKeyFailed(error: Error)
    // status = save to keychain status
    case certCreationFailed(status: OSStatus?)
}

extension SecIdentity
{
    /**
     * Helper method that tries to load an identity from the keychain.
     *
     * - parameter forPrivateKey: the private key for which the identity should be searched
     * - parameter publicKey: the public key for which the identity should be searched; should match the private key
     * - returns: The identity if found, or `nil`.
     */
    private static func findIdentity(forPrivateKey privKey:SecKey, publicKey pubKey:SecKey) -> SecIdentity? {
        guard let identity = SecIdentity.find(withPublicKey:pubKey) else {
            return nil
        }

        // Since the way identities are stored in the keychain is sparsely documented at best,
        // double-check that this identity is the one we're looking for.
        guard let priv = identity.privateKey,
            let retrievedKeyData = priv.keyDataOfRefInKeychain,
            let originalKeyData = privKey.keyDataOfRefInKeychain, retrievedKeyData == originalKeyData else {
            return nil
        }

        return identity
    }

    /**
     * Finds the identity in the keychain based on the given public key.
     * The identity that is returned is the one that has the public key's digest
     * as label.
     *
     * - parameter withPublicKey: the public key that should be used to find the identity, based on it's digest
     * - returns: The identity if found, or `nil`.
     */
    public static func find(withPublicKey pubKey:SecKey) -> SecIdentity? {
        guard let identities = findAll(withPublicKey: pubKey), identities.count == 1 else {
            return nil
        }
        return identities[0]
    }

    /**
     * Finds all identities in the keychain based on the given public key.
     * The identities that are returned are the ones that have the public key's digest
     * as label. Because of the keychain query filters, and on current iOS versions,
     * this should return 0 or 1 identity, not more...
     *
     * - parameter withPublicKey: the public key that should be used to find the identity, based on it's digest
     * - returns: an array of identities if found, or `nil`
     */
    static func findAll(withPublicKey pubKey:SecKey) -> [SecIdentity]? {
        guard let keyData = pubKey.keyDataOfRefInKeychain else {
            return nil
        }
        let sha1 = Digest(algorithm: .sha1)
        _ = sha1.update(buffer: keyData, byteCount: keyData.count)
        let digest = sha1.final()
        let digestData = Data(digest)

        var out: AnyObject?
        let query : [NSString:AnyObject] = [kSecClass as NSString: kSecClassIdentity as NSString,
                                            kSecAttrKeyClass as NSString: kSecAttrKeyClassPrivate as NSString,
                                            kSecMatchLimit as NSString : kSecMatchLimitAll as NSString,
                                            kSecReturnRef as NSString : NSNumber(value: true),
                                            kSecAttrApplicationLabel as NSString : digestData as NSData ]
        let err = SecItemCopyMatching(query as CFDictionary, &out)
        guard err == errSecSuccess else {
            return nil
        }
        let identities = out! as! [SecIdentity]
        return identities
    }

}
