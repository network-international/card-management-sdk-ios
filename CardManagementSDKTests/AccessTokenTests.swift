//
//  AccessTokenTests.swift
//  CardManagementSDKTests
//
//  Created by Aleksei Kiselev on 29.12.2023.
//

import XCTest
@testable import NICardManagementSDK

final class AccessTokenTests: XCTestCase {
    func testTokenCreation() throws {
        let createdNow = Date().timeIntervalSince1970
        let token = AccessToken(value: "my token", expiresIn: 3, created: createdNow)
        XCTAssertEqual(token.value, "my token")
        XCTAssertEqual(token.expiresIn, 3)
        XCTAssertEqual(token.created, createdNow)
    }


    func testTokenNotExpired() throws {
        let createdNow = Date().timeIntervalSince1970
        let token = AccessToken(value: "my token", expiresIn: 3, created: createdNow)
        XCTAssertEqual(token.value, "my token")
        XCTAssertEqual(token.expiresIn, 3)
        XCTAssertEqual(token.created, createdNow)
        XCTAssertEqual(token.isExpired, false)
    }

    func testTokenExpired() throws {
        let created4secondsAgo = Date().timeIntervalSince1970 - 4
        let token = AccessToken(value: "my token", expiresIn: 3, created: created4secondsAgo)
        XCTAssertEqual(token.isExpired, true)
    }
}
