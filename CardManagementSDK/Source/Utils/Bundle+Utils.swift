//
//  Bundle+Utils.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 02.11.2022.
//

import Foundation
import UIKit

class NISDKBundleLocator {}

extension Bundle {
    private static let sdkResourceBundleName = "NICardManagementSDKResources"

    static var sdkBundle: Bundle {
        let frameworkBundle = Bundle(for: NISDKBundleLocator.self)
        let candidateBundles: [Bundle] = [
            frameworkBundle,
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

        return frameworkBundle
    }

    static func sdkImage(named imageName: String) -> UIImage? {
        let candidates: [Bundle] = [
            sdkBundle,
            Bundle(for: NISDKBundleLocator.self),
            Bundle.main
        ]

        for bundle in candidates {
            if let image = UIImage(named: imageName, in: bundle, compatibleWith: nil) {
                return image
            }
        }

        return UIImage(named: imageName)
    }

    static func nibBundle(named nibName: String) -> Bundle {
        let frameworkBundle = Bundle(for: NISDKBundleLocator.self)
        var candidateBundles: [Bundle] = [frameworkBundle]

        if let resourceBundleURL = frameworkBundle.url(
            forResource: sdkResourceBundleName,
            withExtension: "bundle"
        ), let resourceBundle = Bundle(url: resourceBundleURL) {
            candidateBundles.insert(resourceBundle, at: 1)
        }

        if let mainBundle = Bundle.main as Bundle? {
            candidateBundles.append(mainBundle)
        }

        for bundle in candidateBundles {
            if bundle.path(forResource: nibName, ofType: "nib") != nil {
                return bundle
            }
        }

        return frameworkBundle
    }
}
