//
//  FormCoordinator.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation

import UIKit

enum Route {
    case cardDetails
    case setPin(type: NIPinFormType)
    case verifyPin(type: NIPinFormType)
    case changePin(type: NIPinFormType)
}

typealias FormCoordinatorService = CardDetailsService & SetPinService & VerifyPinService & ChangePinService

class FormCoordinator: Coordinator {
    var navigationController: UIViewController
    private let service: FormCoordinatorService
    private let displayAttributes: NIDisplayAttributes
    private let language: NILanguage?
    private let cardViewBackground: UIImage?
    private let cardViewTextPositioning: NICardDetailsTextPositioning?
    
    init(
        navigationController: UIViewController,
        displayAttributes: NIDisplayAttributes = .zero,
        service: FormCoordinatorService,
        language: NILanguage?,
        cardViewBackground: UIImage? = nil,
        cardViewTextPositioning: NICardDetailsTextPositioning? = nil
    ) {
        self.navigationController = navigationController
        self.displayAttributes = displayAttributes
        self.service = service
        self.language = language
        self.cardViewBackground = cardViewBackground
        self.cardViewTextPositioning = cardViewTextPositioning
    }
    
    func coordinate(route: Route, completion: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?) {
        switch route {
        case .cardDetails:
            let vc = CardDetailsViewController(
                language: language,
                displayAttributes: displayAttributes,
                cardBackground: cardViewBackground,
                cardPositioning: cardViewTextPositioning,
                service: service,
                callback: completion
            )
            present(vc)
            
        case let .setPin(pinFormType):
            let viewModel = SetPinViewModel(displayAttributes: displayAttributes, formType: pinFormType, service: service)
            let vc = SetPinViewController(language: language, viewModel: viewModel)
            vc.callback = completion
            push(vc)
            
        case let .verifyPin(pinFormType):
            let viewModel = VerifyPinViewModel(displayAttributes: displayAttributes, formType: pinFormType, service: service)
            let vc = VerifyPinViewController(language: language, viewModel: viewModel)
            vc.callback = completion
            push(vc)
            
        case let .changePin(pinFormType):
            let viewModel = ChangePinViewModel(displayAttributes: displayAttributes, formType: pinFormType, service: service)
            let vc = ChangePinViewController(language: language, viewModel: viewModel)
            vc.callback = completion
            push(vc)
        }
    }
}

