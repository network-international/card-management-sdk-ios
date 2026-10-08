//
//  JSONSerialization.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation

/// https://stackoverflow.com/q/35053577/1033581
extension JSONSerialization {
    
    /// Produce Double values as Decimal values.
    class func decimalData(withJSONObject obj: Any, options opt: JSONSerialization.WritingOptions = [.fragmentsAllowed]) throws -> Data {
        return try data(withJSONObject: decimalObject(obj), options: opt)
    }
    
    fileprivate static let roundingBehavior = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
    
    fileprivate static func decimalObject(_ anObject: Any) -> Any {
        let value: Any

        if let n = anObject as? [String: Any] {
            // subclassing children
            let dic = DecimalDictionary()
            n.forEach { dic.setObject($1, forKey: $0) }
            value = dic
        } else if let n = anObject as? [Any] {
            // subclassing children
            let arr = DecimalArray()
            n.forEach { arr.add($0) }
            value = arr
        } else if let n = anObject as? NSNumber, CFNumberGetType(n) == .doubleType || CFNumberGetType(n) == .float64Type {
            // converting precision for correct decimal output
            value = NSDecimalNumber(value: anObject as! Double).rounding(accordingToBehavior: roundingBehavior) as Decimal
        } else {
            value = anObject
        }
        return value
    }
}

private class DecimalDictionary: NSDictionary {
    let _dictionary: NSMutableDictionary = [:]
    
    override var count: Int {
        return _dictionary.count
    }
    override func keyEnumerator() -> NSEnumerator {
        return _dictionary.keyEnumerator()
    }
    override func object(forKey aKey: Any) -> Any? {
        return _dictionary.object(forKey: aKey)
    }
    
    func setObject(_ anObject: Any, forKey aKey: String) {
        let value = JSONSerialization.decimalObject(anObject)
        _dictionary.setObject(value, forKey: aKey as NSString)
    }
}

private class DecimalArray: NSArray {
    let _array: NSMutableArray = []
    
    override var count: Int {
        return _array.count
    }
    override func object(at index: Int) -> Any {
        return _array.object(at: index)
    }
    
    func add(_ anObject: Any) {
        let value = JSONSerialization.decimalObject(anObject)
        _array.add(value)
    }
}
