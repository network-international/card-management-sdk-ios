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
    var tokenFetchableSimple: NICardManagementTokenFetchable {
        TokenFetcherFactory.makeSimpleWrapper(tokenValue:"put your token here")
    }
    
    var demoTokenFetcher: NICardManagementTokenFetchable {
        TokenFetcherFactory.makeDemoClient(
            urlString: credentials.tokenUrl,
            credentials: .init(
                clientId: credentials.clientId,
                clientSecret: credentials.clientSecret
            )
        )
    }
    
    func buildSdk() -> NICardManagementAPI {
        NICardManagementAPI(
            rootUrl: connection.baseUrl,
            cardIdentifierId: cardIdentifier.Id,
            cardIdentifierType: cardIdentifier.type,
            bankCode: connection.bankCode,
            tokenFetchable: demoTokenFetcher,
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
