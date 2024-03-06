//
//  Copyright © 2016 Stefan van den Oord. All rights reserved.

import Foundation

class OID : NSObject {
    let components: [UInt32]
    init(components: [UInt32]) {
        self.components = components
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? OID else {
            return false
        }
        return components == other.components
    }

    override var hash: Int {
        var hash : Int = 0
        for i in components {
            hash = hash &+ Int(i)
        }
        return hash
    }

    override var description: String {
        var desc = "{"
        for c in components {
            desc += String(format: "%u ", c)
        }
        return desc + "}"
    }
}


extension OID {
    
    /** ALGORITHMS **/
    static let rsaAlgorithmID = OID(components:[1, 2, 840, 113549, 1, 1, 1])
    static let rsaWithSHA256AlgorithmID = OID(components:[1, 2, 840, 113549, 1, 1, 11])
    
    /** SUBJECT **/
    static let commonName = OID(components:[2, 5, 4, 3])

    static let email = OID(components:[1, 2, 840, 113549, 1, 9, 1])
    
    /** USAGE **/
    static let keyUsageOID = OID(components:[2, 5, 29, 15])
    
}


