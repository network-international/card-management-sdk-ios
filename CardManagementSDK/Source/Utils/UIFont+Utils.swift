//
//  UIFont+Utils.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 02.11.2022.
//

import UIKit

extension UIFont {
    
    /// registers default font, provided in the sdk bundle
    static func registerDefaultFonts() {
        UIFont.registerFont(withFilenameString: "OCRA.otf", in: Bundle.sdkBundle)
    }
    
    
    // MARK: - Private
    private static func registerFont(withFilenameString filenameString: String, in bundle: Bundle) {
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            // [UIFont] Failed to register font - path for resource not found."
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            // "[UIFont] Failed to register font - font data could not be loaded."
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            // "[UIFont] Failed to register font - data provider could not be loaded."
            return
        }
        
        guard let font = CGFont(dataProvider) else {
            // "[UIFont] Failed to register font - font could not be loaded."
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            // "[UIFont] Failed to register font - register graphics font failed - this font may have already been registered in the main bundle."
        }
    }
    
}
