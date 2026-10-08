//
// Copyright (c) 2016 Stefan van den Oord. All rights reserved.

import Foundation

extension SecKey {
    
    /**
     * Computes the digital signature of the given data using the current key. This method takes the hash of the data
     * and passes that into `SecKeyRawSign()` with `PKCS1SHA256` padding.
     *
     * Please note that normally this assumes that the current key
     * is a private key, but that is not verified here.
     *
     * - parameter data: the data to sign
     * - returns: The signature of the data, or `nil` if signing failed.
     */
    public func sign(data:[UInt8]) -> [UInt8]? {
        let sha256 = Digest(algorithm: .sha256)
        _ = sha256.update(buffer: data, byteCount: data.count)
        let digest = sha256.final()
        
        // new rsaSignatureDigestPKCS1v15SHA256   rsaSignatureMessagePKCS1v15SHA256
        var error: Unmanaged<CFError>?
        if let signature = SecKeyCreateSignature(self, .rsaSignatureDigestPKCS1v15SHA256, Data(digest) as CFData, &error) {
            let signatureBytes = [UInt8](signature as Data)
            return signatureBytes
        } else {
            print("sign error \(error!.takeRetainedValue() as Error)")
            // throw KeychainError.generateKeyFailed(error: error!.takeRetainedValue() as Error)
        }
        return nil
    }
    
}
