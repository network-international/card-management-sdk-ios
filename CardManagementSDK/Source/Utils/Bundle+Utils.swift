//
//  Bundle+Utils.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 02.11.2022.
//

import Foundation

class NISDKBundleLocator {}

extension Bundle {
    static var sdkBundle: Bundle {
        return Bundle(for: NISDKBundleLocator.self)
    }
}
