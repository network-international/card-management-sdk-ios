//
//  NIResource.swift
//  NICardManagementSDK
//
//  Created by Aleksei Kiselev on 03.04.2024.
//

import Foundation

public enum NIResource {
    enum L10n {
        static let cardNumberKey = "cardmanagement_sdk_card_number"
        static let cardExpiryKey = "cardmanagement_sdk_card_expiry"
        static let cardCvvKey = "cardmanagement_sdk_card_cvv"
        static let cardNameKey = "cardmanagement_sdk_card_name"
        static let cardDetailsTitleKey = "cardmanagement_sdk_card_details_title"

        static let setPinTitleKey = "cardmanagement_sdk_set_pin_title"
        static let setPinEnterKey = "cardmanagement_sdk_set_pin_description_enter_pin"
        static let setPinReenterPinKey = "cardmanagement_sdk_set_pin_description_re_enter_pin"
        static let setPinNotMatchKey = "cardmanagement_sdk_set_pin_description_pin_not_match"

        static let verifyPinTitleKey = "cardmanagement_sdk_verify_pin_title"
        static let verifyPinDescriptionKey = "cardmanagement_sdk_verify_pin_description"

        static let changePinTitleKey = "cardmanagement_sdk_change_pin_title"
        static let changePinEnterCurrentKey = "cardmanagement_sdk_change_pin_description_enter_current_pin"
        static let changePinEnterNewPinKey = "cardmanagement_sdk_change_pin_description_enter_new_pin"
        static let changePinReenterPinKey = "cardmanagement_sdk_change_pin_description_re_enter_new_pin"
        static let changePinNotMatchKey = "cardmanagement_sdk_change_pin_description_pin_not_match"

        static let pinCountdownDescriptionKey = "cardmanagement_sdk_view_pin_countdown_description"
        static let pinCountdownUnitKey = "cardmanagement_sdk_view_pin_countdown_unit"

        
        static let toastMessage = "cardmanagement_sdk_toast_message"
    }
}
