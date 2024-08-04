//
// Copyright (c) 2016 Stefan van den Oord. All rights reserved.

import Security
import Foundation

public extension SecCertificate {

    /**
     * Create an identity using a self-signed certificate. This can fail in many ways, in which case it will return `nil`.
     * Since potential failures are non-recoverable, no details are provided in that case.
     *
     * - parameter ofSize: size of the keys, in bits; default is 3072
     * - parameter subjectCommonName: the common name of the subject of the self-signed certificate that is created
     * - parameter subjectEmailAddress: the email address of the subject of the self-signed certificate that is created
     * - parameter tag: "com.example.keys.bankCode".data(using: .utf8)!
     * - parameter isPermanent: if it should be stored in keychain
     * - returns: The created identity, or `nil` when there was an error.
     */
    // Note: SecItemDelete blocks the calling thread, so it can cause your app’s UI to hang if called from the main thread.
    static func create(
        ofSize bits:UInt = 4096,
        subjectCommonName name:String,
        validFrom: Date,
        validTo: Date,
        tag: Data,
        isPermanent: Bool
    ) throws -> (cert: SecCertificate, privKey: SecKey) {
        // consider deleting old key
        if isPermanent {
            let query: NSDictionary = [
                kSecClass as String: kSecClassKey,
                kSecAttrApplicationTag as String: tag as AnyObject,
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA
            ]
            let delstatus = SecItemDelete(query as CFDictionary)
            guard delstatus == errSecSuccess || delstatus == errSecItemNotFound else {
                throw KeychainError.unhandledError(status: delstatus)
            }
        }
        let keyPair = try SecKey.generateKeyPair(ofSize: bits, tag: tag, isPermanent: isPermanent)
        let certRequest = CertificateRequest(
            forPublicKey:keyPair.publicKey,
            subjectCommonName: name,
            keyUsage: [.DigitalSignature, .DataEncipherment],
            validFrom: validFrom,
            validTo: validTo
        )

        guard
            let signedBytes = certRequest.selfSign(withPrivateKey:keyPair.privateKey),
            let signedCert = SecCertificateCreateWithData(nil, Data(signedBytes) as CFData)
        else {
            throw KeychainError.certCreationFailed(status: nil)
        }
        
        if isPermanent {
            let err = signedCert.storeInKeychain()
            guard err == errSecSuccess else {
                throw KeychainError.certCreationFailed(status: err)
            }
        }

        return (signedCert, keyPair.privateKey)
    }
    /**
     * Loads a certificate from a DER encoded file. Wraps `SecCertificateCreateWithData`.
     *
     * - parameter file: The DER encoded file from which to load the certificate
     * - returns: A `SecCertificate` if it could be loaded, or `nil`
     */
    static func create(derEncodedFile file: String) -> SecCertificate? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: file)) else {
            return nil
        }
        let cfData = CFDataCreateWithBytesNoCopy(nil, (data as NSData).bytes.bindMemory(to: UInt8.self, capacity: data.count), data.count, kCFAllocatorNull)
        return SecCertificateCreateWithData(kCFAllocatorDefault, cfData!)
    }

    /**
     * Returns the data of the certificate by calling `SecCertificateCopyData`.
     *
     * - returns: the data of the certificate
     */
    var data: Data {
        return SecCertificateCopyData(self) as Data
    }

    /**
     * Tries to return the public key of this certificate. Wraps `SecTrustCopyPublicKey`.
     * Uses `SecTrustCreateWithCertificates` with `SecPolicyCreateBasicX509()` policy.
     *
     * - returns: the public key if possible
     */
    func publicKey() throws -> SecKey {
        let policy: SecPolicy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let resultCode = SecTrustCreateWithCertificates([self] as CFArray, policy, &trust)
        guard resultCode == errSecSuccess, let trust = trust else {
            throw KeychainError.certCreationFailed(status: resultCode)
        }
        guard let result = SecTrustCopyPublicKey(trust) else {
            // this can happen if the public key algorithm is not supported
            throw KeychainError.publicKeyNotAvailable
        }
        return result
    }

}

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
