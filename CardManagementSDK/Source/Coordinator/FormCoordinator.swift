//
//  FormCoordinator.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation

import UIKit

enum Route {
    case cardDetails(title: String?, NICardAttributes, NICardDetailsTextPositioning?, UIImage?)
    case setPin(type: NIPinFormType, SetPinViewModel.Config)
    case verifyPin(type: NIPinFormType, VerifyPinViewModel.Config)
    case changePin(type: NIPinFormType, ChangePinViewModel.Config)
}

typealias FormCoordinatorService = CardDetailsService & SetPinService & VerifyPinService & ChangePinService

class FormCoordinator: Coordinator {
    var navigationController: UIViewController
    private let service: FormCoordinatorService
    
    init(
        navigationController: UIViewController,
        service: FormCoordinatorService
    ) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func coordinate(route: Route, completion: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?) {
        switch route {
            
        case let .cardDetails(formTitle, cardAttributes, cardPositioning, cardBackground):
            let vc = CardDetailsViewController(
                title: formTitle,
                cardAttributes: cardAttributes,
                cardBackground: cardBackground,
                cardPositioning: cardPositioning,
                service: service,
                callback: completion
            )
            present(vc)
            
        case let .setPin(pinFormType, config):
            let viewModel = SetPinViewModel(config: config, formType: pinFormType, service: service)
            let vc = SetPinViewController(viewModel: viewModel)
            vc.callback = completion
            push(vc)
            
        case let .verifyPin(pinFormType, config):
            let viewModel = VerifyPinViewModel(config: config, formType: pinFormType, service: service)
            let vc = VerifyPinViewController(viewModel: viewModel)
            vc.callback = completion
            push(vc)
            
        case let .changePin(pinFormType, config):
            let viewModel = ChangePinViewModel(config: config, formType: pinFormType, service: service)
            let vc = ChangePinViewController(viewModel: viewModel)
            vc.callback = completion
            push(vc)
        }
    }
}

