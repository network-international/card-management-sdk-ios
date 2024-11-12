//
//  SettingsProvider.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 17.11.2023.
//

import Foundation
import Combine
import NICardManagementSDK

class SettingsProvider {
    @Published private(set) var settings: SettingsModel
    @Published private(set) var textPosition: TextPositioning

    @Published private(set) var cardBackgroundImage = UIImage(resource: .background)
    
    // Update configs for pin forms if needed
    let pinVerifyConfig = VerifyPinViewModel.Config(
        descriptionAttributedText: NSAttributedString(
            string: NISDKStrings.verify_pin_description.rawValue,
            attributes: [.font : UIElement.PinFormLabel.verifyPinDescription.defaultFont, .foregroundColor: UIColor.label]
        ),
        titleText: NISDKStrings.verify_pin_title.rawValue,
        backgroundColor: .clear
    )
    let pinChangeConfig = ChangePinViewModel.Config(
        enterCurrentPinText: NSAttributedString(
            string: NISDKStrings.change_pin_description_enter_current_pin.rawValue,
            attributes: [.font : UIFont(name: "Helvetica", size: 18) ?? UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.label]
        ),
        enterNewPinText: ChangePinViewModel.Config.default.enterNewPinText,
        reEnterNewPinText: ChangePinViewModel.Config.default.reEnterNewPinText,
        notMatchPinText: ChangePinViewModel.Config.default.notMatchPinText,
        titleText: ChangePinViewModel.Config.default.titleText,
        backgroundColor: ChangePinViewModel.Config.default.backgroundColor
    )
    let pinSetConfig = SetPinViewModel.Config.default

    
    init() {
        settings = Self.readSettings()
        textPosition = .initial
    }
    
    func updateSettings(_ settings: SettingsModel) {
        self.settings = settings
    }
    
    func updateTextPosition(_ textPosition: TextPositioning) {
        self.textPosition = textPosition
    }
}

private extension SettingsProvider {
    static func readSettings() -> SettingsModel {
        let plistData: (_ path: String) -> Data? = { path in
            let url: URL
            if #available(iOS 16.0, *) {
                url = URL(filePath: path)
            } else {
                url = URL(fileURLWithPath: path)
            }
            return try? Data(contentsOf: url)
        }
        
        guard
            let path = Bundle.main.path(forResource: "Settings", ofType: "plist"),
            let data = plistData(path),
            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
            let dict = plist["CardView"] as? [String: Any],
            let settings = SettingsModel.decode(from: dict)
        else { return .zero }
        
        return settings
    }
}

fileprivate extension SettingsModel {
    static var zero: SettingsModel {
        .init(
            connection: .init(baseUrl: "", bankCode: ""),
            cardIdentifier: .init(Id: "", type: ""),
            pinType: .initial, 
            credentials: .init(tokenUrl: "", clientId: "", clientSecret: "")
        )
    }
}

// Have to use proxy, as NICardDetailsTextPositioning's fields has internal access level
struct TextPositioning {
    static var initial: TextPositioning {
        TextPositioning(
            leftAlignment: 0.1,
            cardNumberGroupTopAlignment: 0.1,
            dateCvvGroupTopAlignment: 0.4,
            cardHolderNameGroupTopAlignment: 0.7
        )
    }
    
    var leftAlignment: Double = Self.initial.leftAlignment
    var cardNumberGroupTopAlignment: Double = Self.initial.cardNumberGroupTopAlignment
    var dateCvvGroupTopAlignment: Double = Self.initial.dateCvvGroupTopAlignment
    var cardHolderNameGroupTopAlignment: Double = Self.initial.cardHolderNameGroupTopAlignment
    
    var sdkValue: NICardDetailsTextPositioning {
        NICardDetailsTextPositioning(
            leftAlignment: leftAlignment,
            cardNumberGroupTopAlignment: cardNumberGroupTopAlignment,
            dateCvvGroupTopAlignment: dateCvvGroupTopAlignment,
            cardHolderNameGroupTopAlignment: cardHolderNameGroupTopAlignment
        )
    }
}
