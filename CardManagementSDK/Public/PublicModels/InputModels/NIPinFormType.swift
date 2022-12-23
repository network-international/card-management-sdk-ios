//
//  NIPinFormType.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 20.10.2022.
//

import Foundation

/// There three types of pin views with 4, 5 and 6 digits
@objc public enum NIPinFormType: Int, CaseIterable {
    case dynamic = 0
    case fourDigits = 4
    case fiveDigits = 5
    case sixDigits = 6
}
