//
//  TokenFetchIntegrationTests.swift
//  CardManagementSDKTests
//
//  Created by Aleksei Kiselev on 29.12.2023.
//

import XCTest
@testable import NICardManagementSDK

final class TokenFetchIntegrationTests: XCTestCase {

    private var tokenFetcher: NICardManagementTokenFetchable!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSimpleWrapper() throws {
        // Arrange
        tokenFetcher = TokenFetcherFactory.makeSimpleWrapper(tokenValue: "my Token value$", expiresIn: 25)
        let expectetion = expectation(description: "Got token")
        var token: NIAccessToken?
        // Act
        tokenFetcher.fetchToken { result in
            token = try? result.get()
            expectetion.fulfill()
        }
        waitForExpectations(timeout: 3)
        // Assert
        guard let token = token else {
            XCTFail("Token is nil")
            return
        }
        XCTAssertEqual(token.expiresIn, 25)
        XCTAssertEqual(token.value, "my Token value$")
        XCTAssertEqual(token.isExpired, false)
    }

    func testNetworkFetcher() throws {
        // Arrange
        let urlString = "https://apitest.network.ae/CardServices/v2/Token"
        let credentials = NIClientCredentials(clientId: "6rxqcbjuejesgw95htm4r3vg",
                                            clientSecret: "hnCqJYwuzt")
        tokenFetcher = TokenNetworkFetcher(urlString: urlString, credentials: credentials, timeoutInterval: 30)
        let expectetion = expectation(description: "Got token")
        var token: NIAccessToken?
        // Act
        tokenFetcher.fetchToken { result in
            token = try? result.get()
            expectetion.fulfill()
        }
        waitForExpectations(timeout: 30)
        // Assert
        guard let token = token else {
            XCTFail("Token is nil")
            return
        }
        XCTAssertEqual(token.expiresIn, 3600)
        XCTAssertFalse(token.value.isEmpty)
        XCTAssertEqual(token.isExpired, false)
    }

}
