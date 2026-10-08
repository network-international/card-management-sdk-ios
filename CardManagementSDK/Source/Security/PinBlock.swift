//
//  PinBlock.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 13.10.2022.
//

import Foundation

// PinBlock ISO 9564 format 0
///The ISO-0 PIN Block format is probably the most used PIN block in the world.
///Its significant characteristic is that it ties the PIN to a specific PAN as part of the block data.
///In order to extract the correct PIN from the block, the PAN must be known (transferred with the PIN block).
///The data in an ISO PIN Block 0 is the XOR of two data items, the PIN and the PAN.


///Steps for calculating this type of encoding by example:
///1. Format a 16 byte PIN as follows: [0] [Length][PIN] [Padding]
///where [0] indicates using ISO-0 format, [Length] is one byte Length, [PIN] is the provided PIN, and [Padding] is usually 'F'
///So, for a PIN= '123456' the padded PIN should be:'06123456FFFFFFFF'
///
///2. Format a 16 byte PAN as follows:[0000][12 digit PAN]
///get the 12 rightmost digits of the PAN [excluding the check digit] and left pad the result with zeros.
///
///So, for a PAN= '5432101234567890' the padded PAN should be: '0000210123456789'
///3. XOR the 2 values: 06123456FFFFFFFF XOR 0000210123456789 = [06121557DCBA9876] This is the clear PIN block.


// Encoding and Decoding PinBlock

class PinBlock {
    
    /**
     * Encode pinblock format 0 (ISO 9564)
     * @param pin pin
     * @param pan primary account number (PAN)
     * @return pinblock in HEX format
     */
    static func createPinBlock(_ pin: String, _ pan: String) -> String {
        // PIN
        let isoFormat = "0"
        let pinLenght =  String(pin.count)
        let pinHead = isoFormat + pinLenght + pin
        let formattedPin = pinHead.padding(toLength: 16, withPad: "F", startingAt: 0)
        
        // PAN
        let formattedPan = "0000" + pan.prefix(pan.count-1).suffix(12)
        
        // PIN BLOCK
        let pinBlock = Data.xor(left: formattedPin.hexaData, right: formattedPan.hexaData).hexa
        return pinBlock
    }
}


extension Data {
    static func xor(left: Data, right: Data) -> Data {
        if left.count != right.count {
            NSLog("Warning! XOR operands are not equal. left = \(left), right = \(right)")
        }
        
        var result: Data = Data()
        var smaller: Data, bigger: Data
        if left.count <= right.count {
            smaller = left
            bigger = right
        } else {
            smaller = right
            bigger = left
        }
        
        let bs:[UInt8] = Array(smaller)
        let bb:[UInt8] = Array(bigger)
        var br = [UInt8] ()
        for i in 0..<bs.count {
            br.append(bs[i] ^ bb[i])
        }
        for j in bs.count..<bb.count {
            br.append(bb[j])
        }
        result = Data(br)
        return result
    }
}

extension String {
    var hexaBytes: [UInt8] {
        var position = startIndex
        return (0..<count/2).compactMap { _ in
            defer { position = index(position, offsetBy: 2) }
            return UInt8(self[position...index(after: position)], radix: 16)
        }
    }
    var hexaData: Data { return hexaBytes.data }
}

private extension Collection where Element == UInt8 {
    var data: Data {
        return Data(self)
    }
}

extension Collection where Element == UInt8 {
    var hexa: String {
        return map{ String(format: "%02X", $0) }.joined()
    }
}
