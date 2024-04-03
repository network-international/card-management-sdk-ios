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
        
        let digestData = Data(digest)
        var error: Unmanaged<CFError>?
        guard let cfData = SecKeyCreateSignature(self, .rsaEncryptionPKCS1, digestData as CFData, &error) else {
            // TODO: throw RSACryptoError.decryptError(error!.takeRetainedValue() as Error)
            return nil
        }
        return Array(cfData as Data)
    }
    
}
