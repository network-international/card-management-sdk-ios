//
//  Copyright © 2016 Stefan van den Oord. All rights reserved.

import Foundation
//import SwiftBytes

extension NSNull {
    func toDER() -> [UInt8] {
        return writeDER(tag: 5, constructed: false, bytes: [])
    }
}

extension Bool {
    func toDER() -> [UInt8] {
        let value : UInt8 = self ? 0xFF : 0x00
        return writeDER(tag:1, constructed:false, bytes:[value])
    }
}


extension UnsignedInteger {
    
    func bytes(_ eightBytes : UInt64) -> [UInt8] {
        let b0 = UInt8(eightBytes >> 56)
        let b1 = UInt8((eightBytes >> 48) & 0xFF)
        let b2 = UInt8((eightBytes >> 40) & 0xFF)
        let b3 = UInt8((eightBytes >> 32) & 0xFF)
        let b4 = UInt8((eightBytes >> 24) & 0xFF)
        let b5 = UInt8((eightBytes >> 16) & 0xFF)
        let b6 = UInt8((eightBytes >> 8) & 0xFF)
        let b7 = UInt8((eightBytes) & 0xFF)
        return [b0, b1, b2, b3, b4, b5, b6, b7]
    }
    
    func encodeForDER() -> [UInt8] {
        
        var bytes : [UInt8] = bytes(UInt64(self)).removeLeadingZeros() //SwiftBytes.bytes(UInt64(self)).removeLeadingZeros()
        if (bytes[0] & 0x80) == 0x80 {
            bytes = [0x00] + bytes
        }
        return bytes
    }
    func toDER() -> [UInt8] {
        return writeDER(tag: 2, constructed: false, bytes: self.encodeForDER())
    }
}

extension BinaryInteger {
    func toDER() -> [UInt8] {
        if self >= 0 {
            return UInt64(self).toDER()
        }
        else {
            let bitPattern = ~(-Int64(self)) + 1
            let twosComplement = UInt64(bitPattern:bitPattern)
            let bytes : [UInt8] = bytes(twosComplement).ensureSingleLeadingOneBit() ///SwiftBytes.bytes(twosComplement).ensureSingleLeadingOneBit()
            return writeDER(tag: 2, constructed: false, bytes: bytes)
        }
    }
    
    func bytes(_ eightBytes : UInt64) -> [UInt8] {
        let b0 = UInt8(eightBytes >> 56)
        let b1 = UInt8((eightBytes >> 48) & 0xFF)
        let b2 = UInt8((eightBytes >> 40) & 0xFF)
        let b3 = UInt8((eightBytes >> 32) & 0xFF)
        let b4 = UInt8((eightBytes >> 24) & 0xFF)
        let b5 = UInt8((eightBytes >> 16) & 0xFF)
        let b6 = UInt8((eightBytes >> 8) & 0xFF)
        let b7 = UInt8((eightBytes) & 0xFF)
        return [b0, b1, b2, b3, b4, b5, b6, b7]
    }
}

extension Sequence where Iterator.Element : BinaryInteger {
    func removeLeading(_ number:Iterator.Element) -> [Iterator.Element] {
        if self.min() == nil { return [] }
        var nonNumberFound = false
        let flat = self.compactMap { (elem:Iterator.Element) -> Iterator.Element? in
            if (elem == number && !nonNumberFound ) {
                return nil
            } else {
                nonNumberFound = true
                return elem
            }
        }
        return flat
    }
    
    func removeLeadingZeros() -> [Iterator.Element] {
        if self.min() == nil { return [] }
        let removedZeros = self.removeLeading(0)
        if removedZeros.count == 0 {
            return [0]
        }
        else {
            return removedZeros
        }
    }
    
    func ensureSingleLeadingOneBit() -> [Iterator.Element] {
        if self.min() == nil { return [] }
        let removedFF = self.removeLeading(0xFF)
        if removedFF.count == 0 {
            return [0xFF]
        }
        else if  removedFF[0] & 0x80 != 0x80 {
            return [0xFF] + removedFF
        }
        return removedFF
    }
}

extension String {
    
    private static let notPrintableCharSet : NSMutableCharacterSet = {
        let charset = NSMutableCharacterSet(charactersIn:" '()+,-./:=?")
        charset.formUnion(with: CharacterSet.alphanumerics);
        charset.invert();
        return charset;
    }()
    
    func toDER() -> [UInt8] {
        if let asciiData = self.data(using: String.Encoding.ascii) {
            var tag:UInt8 = 19; // printablestring (a silly arbitrary subset of ASCII defined by ASN.1)
            if let range = self.rangeOfCharacter(from: String.notPrintableCharSet as CharacterSet), /*!forcePrintableStrings && */range.upperBound > range.lowerBound {
                tag = 20 // IA5string (full 7-bit ASCII)
            }
            return writeDER(tag: tag, tagClass: 0, constructed: false, bytes: asciiData.bytes)
        } else {
            let utf8Bytes = [UInt8](self.utf8)
            return writeDER(tag: 12, constructed: false, bytes: utf8Bytes)
        }
    }
}

extension Data {

    public var bytes: [UInt8] {
        var result: [UInt8] = [UInt8](repeating: 0, count: self.count)
        (self as NSData).getBytes(&result, length:self.count)
        return result
    }

}


extension BitString {
    func toDER() -> [UInt8] {
        let bytes = writeDERHeader(tag: 3, tagClass: 0, constructed: false, length: UInt64(1+bitCount/8))
        let unused = UInt8((8 - (bitCount % 8)) % 8)
        return bytes + [unused] + data
    }
}

var berGeneralizedTimeFormatter: DateFormatter {
    let df = DateFormatter()
    df.dateFormat = "yyyyMMddHHmmss'Z'"
    df.timeZone = TimeZone(identifier: "GMT")
    df.locale = Locale(identifier: "nb")
    return df
}

extension Date {
    func toDER() -> [UInt8] {
        let dateString = berGeneralizedTimeFormatter.string(from: self)
        return writeDER(tag: 24, constructed: false, bytes: [UInt8](dateString.utf8))
    }
}

extension Data {
    func toDER() -> [UInt8] {
        return writeDER(tag: 4, tagClass: 0, constructed: false, bytes: self.bytes)
    }
}

extension OID {
    func toDER() -> [UInt8] {
        var bytes = [UInt8]()
        var index = 0
        if (components.count >= 2 && components[0] <= 3 && components[1] < 40) {
            bytes.append(UInt8(components[0]) * 40 + UInt8(components[1]))
            index = 2
        }
        while index < components.count {
            var nonZeroAdded = false
            let component = components[index]
            for shift in stride(from: 28, through: 0, by: -7) {
                let byte = UInt8((component >> UInt32(shift)) & 0x7F)
                if (byte != 0 || nonZeroAdded) {
                    if (nonZeroAdded) {
                        bytes[bytes.count-1] |= 0x80
                    }
                    bytes.append(byte)
                    nonZeroAdded = true
                }
            }
            index = index + 1
        }
        return writeDER(tag: 6, tagClass: 0, constructed:  false, bytes: bytes)
    }
}

struct DERSequence {
    let contentsGenerator:()->[UInt8]
    func toDER() -> [UInt8] {
        return writeDER(tag: 16, constructed: true, bytes: contentsGenerator())
    }
}

extension ASN1Object {
    func toDER() -> [UInt8] {
        if let comps = self.components {
            return encodeCollection(comps, tag: self.tag, tagClass: self.tagClass)
        }
        else if let data = self.value {
            return writeDER(tag: self.tag, tagClass: self.tagClass, constructed: self.constructed, bytes: data)
        }
        else {
            assertionFailure("ASN1Object should have either components or value, but has neither")
            return []
        }
    }
}

extension NSArray {
    func toDER() -> [UInt8] {
        var objects = self as? [NSObject]
        if objects == nil {
            var copy = Array<NSObject>()
            for o in self {
                copy.append(o as! NSObject)
            }
            objects = copy
        }
        guard let collection = objects else {
            assertionFailure("Unable to endcode array")
            return []
        }
        return encodeCollection(collection, tag:16, tagClass: 0)
    }
}

extension NSSet {
    func toDER() -> [UInt8] {
        var objects = [NSObject]()
        for o in self {
            objects.append(o as! NSObject)
        }
        return encodeCollection(objects, tag: 17, tagClass: 0)
    }
}

extension Sequence where Iterator.Element == NSObject {
    
}

extension NSNumber {
    func toDER() -> [UInt8] {
        // Special-case detection of booleans by pointer equality, because otherwise they appear
        // identical to 0 and 1:
        if (self===NSNumber(value: true) || self===NSNumber(value: false)) {
            let value:UInt8 = self===NSNumber(value: true) ?0xFF :0x00;
            return writeDER(tag: 1, constructed: false, bytes: [value])
        }
        
        guard let objcType = String(validatingUTF8: self.objCType) else {
            assertionFailure("Could not get objcType of NSNumber")
            return []
        }
        
        if (objcType.count == 1) {
            switch(objcType) {
            case "c", "i", "s", "l", "q":
                return self.int64Value.toDER()
            case "C", "I", "S", "L", "Q":
                return self.uint64Value.toDER()
            case "B":
                return self.boolValue.toDER()
            default:
                assertionFailure("Cannot DER encode NSNumber of type \(objcType)")
                return []
            }
        }
        
        assertionFailure("Cannot DER encode NSNumber of type \(objcType)")
        return []
    }
}

extension NSObject {
    func toDER_manualDispatch() -> [UInt8] {
        if let d = self as? Date {
            let bytes = d.toDER()
            return bytes
        }
        else if let n = self as? NSNull {
            let bytes = n.toDER()
            return bytes
        }
        else if let a = self as? NSArray {
            let bytes = a.toDER()
            return bytes
        }
        else if let s = self as? NSSet {
            let bytes = s.toDER()
            return bytes
        }
        else if let num = self as? NSNumber {
            let bytes = num.toDER()
            return bytes
        }
        else if let str = self as? NSString {
            let bytes = (str as String).toDER()
            return bytes
        }
        else if let asn1 = self as? ASN1Object {
            let bytes = asn1.toDER()
            return bytes
        }
        else if let oid = self as? OID {
            let bytes = oid.toDER()
            return bytes
        }
        else if let bitStr = self as? BitString {
            let bytes = bitStr.toDER()
            return bytes
        }
        else if let data = self as? Data {
            let bytes = data.toDER()
            return bytes
        }
        else {
            assertionFailure("toDER_manualDispatch not defined for object \(self)")
            return []
        }
    }
}
    
private func encodeCollection(_ collection:[NSObject], tag:UInt8, tagClass:UInt8) -> [UInt8] {
    var bytes = [UInt8]()
    for o in collection {
        bytes += o.toDER_manualDispatch()
    }
    return writeDER(tag: tag, tagClass: tagClass, constructed: true, bytes: bytes)
}

func writeDER(tag:UInt8, tagClass:UInt8 = 0, constructed:Bool, bytes:[UInt8]) -> [UInt8] {
    return writeDERHeader(tag: tag, tagClass: tagClass, constructed: constructed, length: UInt64(bytes.count)) + bytes
}

func writeDERHeader(tag:UInt8, tagClass:UInt8 = 0, constructed:Bool, length:UInt64) -> [UInt8] {
    let constructedBits : UInt8 = (constructed ? 1 : 0) << 5
    let classBits : UInt8 = tagClass << 6
    let headerByte1 : UInt8 = tag | constructedBits | classBits
    
    var headerByte2 : UInt8 = 0
    var headerExtraLength = [UInt8]()
    if length < 128 {
        headerByte2 = UInt8(length)
    }
    else {
        let l = UInt64(length)
        headerExtraLength = l.encodeForDER()
        headerByte2 = UInt8(headerExtraLength.count) | 0x80
    }
    return [headerByte1] + [headerByte2] + headerExtraLength
}
