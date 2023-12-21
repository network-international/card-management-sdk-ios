//
//  CardDetailsViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 07.10.2022.
//

import Foundation
import UIKit

public protocol CardDetailsService {
    func getCardDetails(completion: @escaping (NICardDetailsResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)
}

class CardDetailsViewModel {

    var callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    
    private let displayAttributes: NIDisplayAttributes?
    private let service: CardDetailsService
    
    private (set) var cardDetails: CardDetails? {
        didSet {
            self.bindCardDetailsViewModel()
        }
    }
    
    var bindCardDetailsViewModel = {}
    var backgroundImage: UIImage?
    
    var closeButtonImageName: String {
        displayAttributes?.theme == .light ? "icon_close" : "icon_close_white"
    }
    var isThemeLight: Bool {
        displayAttributes?.theme == .light
    }
    
    init(displayAttributes: NIDisplayAttributes?, service: CardDetailsService) {
        self.displayAttributes = displayAttributes
        self.service = service
        
        self.backgroundImage = displayAttributes?.cardAttributes?.backgroundImage
        
        cardDetails = CardDetails(cardNumberLabel: "card_number".localized,
                                  cardExpiryLabel: "card_expiry".localized,
                                  cvv2Label: "card_cvv".localized,
                                  cardholderNameLabel: "card_name".localized)
        
        
        service.getCardDetails { [weak self] success, error, callback in
            guard let self = self else { return }
            
            if let response = success {
                if self.mapResponseToCardDetails(response) {
                    self.callback?(NISuccessResponse(message: "Card details retrieved with success!"), error){}
                } else {
                    self.callback?(nil, NIErrorResponse(error: NISDKErrors.NO_DATA_ERROR)){}
                }
            } else {
                self.callback?(nil, error){}
                self.mapNoDataResponseToCardDetails()
            }
        }
    }
    
    private func mapResponseToCardDetails(_ response: NICardDetailsResponse) -> Bool {
        guard let cardNumber = response.clearPan, let maskedCardNumber = response.maskedPan, let expiry = response.expiry, let cvv2 = response.clearCVV2, let cardholderName = response.cardholderName else {
            mapNoDataResponseToCardDetails()
            return false
        }
        
        self.cardDetails?.cardNumber = cardNumber.separate(every: 4, with: " ")
        self.cardDetails?.maskedCardNumber = maskedCardNumber.separate(every: 4, with: " ")
        self.cardDetails?.cardholderName = cardholderName
        self.cardDetails?.cardExpiry = expiry
        self.cardDetails?.cvv2 = cvv2
        return true
    }
    
    private func mapNoDataResponseToCardDetails() {
        self.cardDetails?.cardNumber = "-"
        self.cardDetails?.cardholderName = "-"
        self.cardDetails?.cardExpiry = "-"
        self.cardDetails?.cvv2 = "-"
        self.cardDetails?.maskedCardNumber = "-"
    }
    
}

// MARK: - Helpers/Utils
extension CardDetailsViewModel {
    func font(for label: NILabels) -> UIFont? {
        displayAttributes?.font(for: label)
    }
    
    var maskedDetails: CardDetails {
        var maskedHolder = ""
        if let holderNames = self.cardDetails?.cardholderName?.components(separatedBy: " ") {
            for name in holderNames {
                maskedHolder.append("\(name.masked(offset: 2))")
            }
        }
        
        var maskedExpiry = ""
        if let dateComponents = self.cardDetails?.cardExpiry?.components(separatedBy: "/") {
            for dateComponent in dateComponents {
                maskedExpiry.append("\(dateComponent.masked(offset: 0))")
                if dateComponent == dateComponents.first {
                    maskedExpiry.append("/")
                }
            }
        }
        
        let maskedDetails = CardDetails(cardNumberLabel: "card_number".localized,
                                        cardNumber: self.cardDetails?.maskedCardNumber,
                                        maskedCardNumber: self.cardDetails?.maskedCardNumber,
                                        cardholderName: maskedHolder,
                                        cardExpiryLabel: "card_expiry".localized,
                                        cardExpiry: maskedExpiry,
                                        cvv2Label: "card_cvv".localized,
                                        cvv2: self.cardDetails?.cvv2?.masked(),
                                        cardholderNameLabel: "card_name".localized)
        
        return maskedDetails
    }
    
    var shouldMask: Bool {
        return displayAttributes?.cardAttributes?.shouldHide ?? true
    }
    
    var textPositioning: NICardDetailsTextPositioning? {
        return displayAttributes?.cardAttributes?.textPositioning ?? nil
    }
    
}

private extension String {
    
    func masked(_ character: String = "*", offset: Int = 0) -> String {
        guard !self.isEmpty, self.count > offset else { return self }
        let start = self.startIndex ..< self.index(self.startIndex, offsetBy: offset)
        let end = self.index(self.endIndex, offsetBy: 0) ..< self.endIndex
        let result = self[start] + Array(repeating: "*", count: self.count - offset) + self[end]
        return String(result)
    }
    
}
