//
//  NibLoadable.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 25.11.2022.
//

import UIKit

protocol NibLoadable: AnyObject {
    static func instantiateFromNib<T: UIView>() -> T
}

extension NibLoadable where Self: UIView {
    
    static func instantiateFromNib<T: UIView>() -> T {
        let bundle = Bundle.nibBundle(named: String(describing: self))
        return bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)?[0] as! T
    }
    
}
