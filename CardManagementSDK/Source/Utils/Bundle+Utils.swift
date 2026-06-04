//
//  Bundle+Utils.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 02.11.2022.
//

import Foundation

class NISDKBundleLocator {}

extension Bundle {
    private static let sdkResourceBundleName = "NICardManagementSDKResources"

    static var sdkBundle: Bundle {
        let candidateBundles: [Bundle] = [
            Bundle(for: NISDKBundleLocator.self),
            Bundle.main
        ]

        for candidate in candidateBundles {
            if let bundleURL = candidate.url(
                forResource: sdkResourceBundleName,
                withExtension: "bundle"
            ), let bundle = Bundle(url: bundleURL) {
                return bundle
            }
        }

        return Bundle(for: NISDKBundleLocator.self)
    }
}
