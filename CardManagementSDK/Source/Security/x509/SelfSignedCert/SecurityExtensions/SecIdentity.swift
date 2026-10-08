//
// Copyright (c) 2016 Stefan van den Oord. All rights reserved.

import Foundation
import Security

public extension SecIdentity {

    /**
     * Returns the certificate that belongs to the identity. Wraps `SecIdentityCopyCertificate`.
     *
     * - returns: the certificate, if possible
     */
    var certificate: SecCertificate? {
        var uCert: SecCertificate?
        let status = SecIdentityCopyCertificate(self, &uCert)
        if (status != errSecSuccess) {
            return nil
        }
        return uCert
    }

}
