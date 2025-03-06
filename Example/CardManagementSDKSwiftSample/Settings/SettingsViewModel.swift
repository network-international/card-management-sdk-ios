//
//  SettingsViewModel.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 17.11.2023.
//

import Foundation
import NICardManagementSDK

final class AdditionalDemoHeadersProvider: NICardManagementExtraHeaders {
    func additionalNetworkHeaders() -> [String: String] {
        ["extraHeader1": "DemoExtraHttpHeaderValue"]
    }
}

final class SettingsViewModel {
    let settingsProvider: SettingsProvider
    
    init(settingsProvider: SettingsProvider) {
        self.settingsProvider = settingsProvider
    }
    
    func updateSettings(_ settings: SettingsModel) {
        settingsProvider.updateSettings(settings)
    }
}



extension SettingsModel {
    func makeStaticTokenFetcher(_ token: String) -> NICardManagementTokenFetchable {
        TokenFetcherFactory.makeSimpleWrapper(tokenValue: token)
    }
    
    func makeDemoTokenFetcher(tokenUrl: String, clientId: String, clientSecret: String) -> NICardManagementTokenFetchable {
        TokenFetcherFactory.makeDemoClient(
            urlString: tokenUrl,
            credentials: .init(
                clientId: clientId,
                clientSecret: clientSecret
            )
        )
    }
    
    func buildSdk() -> NICardManagementAPI {
        let tokenFetcher: NICardManagementTokenFetchable
        switch self.credentials {
        case let .staticToken(token):
            tokenFetcher = makeStaticTokenFetcher(token)
        case let .demoTokenFetcher(values):
            tokenFetcher = makeDemoTokenFetcher(tokenUrl: values.tokenUrl, clientId: values.clientId, clientSecret: values.clientSecret)
        }
        
        return NICardManagementAPI(
            rootUrl: connection.baseUrl,
            cardIdentifierId: cardIdentifier.Id,
            cardIdentifierType: cardIdentifier.type,
            bankCode: connection.bankCode,
            tokenFetchable: tokenFetcher,
            // pass nil if there are no needs in extra headers
            extraHeadersProvider: AdditionalDemoHeadersProvider(),
            // pass nil or add logger for debugging, like NICardManagementLogging()
            logger: NICardManagementLogging()
        )
    }
}
/* Logger example */
struct NICardManagementLogging: NICardManagementLogger {
    func logNICardManagementMessage(_ message: String) {
        print(message)
    }
}
