//
//  CardDetailsViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 07.10.2022.
//

import Foundation
import UIKit

class CardDetailsViewModel: NSObject {
    
    var input: NIInput
    var callback: ((NISuccessResponse?, NIErrorResponse?) -> Void)?
    
    private (set) var cardDetails: CardDetails? {
        didSet {
            self.bindCardDetailsViewModel()
        }
    }
    
    var bindCardDetailsViewModel = {}
    var backgroundImage: UIImage?
    
    init(input: NIInput) {
        self.input = input
        super.init()
        
        self.backgroundImage = input.displayAttributes?.cardAttributes?.backgroundImage
        
        cardDetails = CardDetails(cardNumberLabel: "card_number".localized,
                                  cardExpiryLabel: "card_expiry".localized,
                                  cvv2Label: "card_cvv".localized,
                                  cardholderNameLabel: "card_name".localized)
        
        
        NICardManagementAPI.getCardDetails(input: input) { [weak self] response, error in
            guard let self = self else { return }
            
            if let response = response {
                self.mapResponseToCardDetails(response)
                self.callback?(NISuccessResponse(message: "Card details retrieved with success!"), error)
            } else {
                self.callback?(nil, error)
                self.cardDetails?.cardNumber = "-"
                self.cardDetails?.cardholderName = "-"
                self.cardDetails?.cardExpiry = "-"
                self.cardDetails?.cvv2 = "-"
                self.cardDetails?.maskedCardNumber = "-"
            }
        }
    }
    
    private func mapResponseToCardDetails(_ response: NICardDetailsResponse) {
        guard let cardNumber = response.clearPan, let maskedCardNumber = response.maskedPan, let expiry = response.expiry, let cvv2 = response.clearCVV2, let cardholderName = response.cardholderName else {
            return
        }
        
        self.cardDetails?.cardNumber = cardNumber.separate(every: 4, with: " ")
        self.cardDetails?.maskedCardNumber = maskedCardNumber.separate(every: 4, with: " ")
        self.cardDetails?.cardholderName = cardholderName
        self.cardDetails?.cardExpiry = expiry
        self.cardDetails?.cvv2 = cvv2
    }
    
}

// MARK: - Helpers/Utils
extension CardDetailsViewModel {
    func font(for label: NILabels) -> UIFont? {
        input.displayAttributes?.font(for: label)
    }
    
    var maskedDetails: CardDetails {
        var maskedHolder = ""
        if let holderNames = self.cardDetails?.cardholderName?.components(separatedBy: " ") {
            for name in holderNames {
                maskedHolder.append("\(name.masked(offset: 2)) ")
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
        return input.displayAttributes?.cardAttributes?.shouldHide ?? true
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
