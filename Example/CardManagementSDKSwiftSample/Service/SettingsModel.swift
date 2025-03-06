//
//  SettingsViewModel.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 16.11.2023.
//

import Foundation
import NICardManagementSDK

struct SettingsModel {
    var connection: Connection
    var cardIdentifier: CardIdentifier
    var pinType: NIPinFormType
    var credentials: Credentials
}

extension SettingsModel {
    struct Connection {
        var baseUrl: String
        var bankCode: String
    }
    struct CardIdentifier {
        var Id: String
        var type: String
    }
    
    struct DemoTokenFetcher {
        var tokenUrl: String
        var clientId: String
        var clientSecret: String
    }
    enum Credentials {
        case demoTokenFetcher(DemoTokenFetcher)
        case staticToken(String)
        var isStatic: Bool {
            switch self {
            case .demoTokenFetcher:
                return false
            case .staticToken:
                return true
            }
        }
    }
}

extension SettingsModel {
    static func decode(from dict: [String: Any]) -> Self? {
        guard
            let connection = Connection.decode(from: dict["connection"] as? [String: String] ?? [:]),
            let cardIdentifier = CardIdentifier.decode(from: dict["cardIdentifier"] as? [String: String] ?? [:])
        else { return nil }
        let credentials = Credentials.decode(from: dict["credentials"] as? [String: String] ?? [:])
        ?? .staticToken("put your token here")
        return .init(
            connection: connection,
            cardIdentifier: cardIdentifier,
            pinType: .initial, 
            credentials: credentials
        )
    }
}
extension SettingsModel.Connection {
    static func decode(from dict: [String: String]) -> Self? {
        guard
            let baseUrl = dict["baseUrl"],
            let bankCode = dict["bankCode"]
        else { return nil }
        return .init(baseUrl: baseUrl, bankCode: bankCode)
    }
}
extension SettingsModel.CardIdentifier {
    static func decode(from dict: [String: String]) -> Self? {
        guard let id = dict["Id"], let type = dict["type"] else { return nil }
        return .init(Id: id, type: type)
    }
}
extension SettingsModel.Credentials {
    static func decode(from dict: [String: String]) -> Self? {
        guard
            let tokenUrl = dict["demoTokenUrl"],
            let clientId = dict["demoClientId"],
            let clientSecret = dict["demoClientSecret"]
        else { return nil }
        return .demoTokenFetcher(.init(tokenUrl: tokenUrl, clientId: clientId, clientSecret: clientSecret))
    }
}

extension NIPinFormType {
    // according to SDK if no pinType provided - use `.dynamic`
    static var initial: Self { .fourDigits }
}
