//
//  CardManagementSDKTests.swift
//  CardManagementSDKTests
//

import XCTest
@testable import NICardManagementSDK

final class CardManagementSDKTests: XCTestCase {
    func testCoreFacadeIsReexported() {
        let client = NICardManagementAPI(
            rootUrl: "https://example.invalid",
            cardIdentifierId: "card-id",
            cardIdentifierType: "EXID",
            bankCode: "BANK",
            tokenFetchable: TokenFetcherFactory.makeSimpleWrapper(tokenValue: "test-token", expiresIn: 60)
        )
        XCTAssertEqual(NICardManagementAPI.version, "0.1.0-dev")
        XCTAssertTrue(client is FormCoordinatorService)
        XCTAssertTrue(client is ViewPinService)
    }
}
