//
//  NICardAttributes.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 30.11.2022.
//

import Foundation
import UIKit

@objc public class NICardAttributes: NSObject {
    
    /// if true, the card details will be hidden/masked by default; if false, the card details will be visible by default
    public var shouldHide: Bool? = true
    
    /// if set, this image will be used as background for the card details view; if not set, it will use default image from sdk
    public var backgroundImage: UIImage?
    
    @objc public init(shouldHide: Bool, backgroundImage: UIImage) {
        self.shouldHide = shouldHide
        self.backgroundImage = backgroundImage
    }
    
}
