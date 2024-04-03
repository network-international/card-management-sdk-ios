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
    
    init(navigationController: UIViewController, displayAttributes: NIDisplayAttributes = .default, service: FormCoordinatorService) {
        self.navigationController = navigationController
        self.displayAttributes = displayAttributes
        self.service = service
    }
    
    func coordinate(route: Route, completion: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?) {
        switch route {
        case .cardDetails:
            let vc = CardDetailsViewController(displayAttributes: displayAttributes, service: service, callback: completion)
            present(vc)
            
        case let .setPin(pinFormType):
            let viewModel = SetPinViewModel(displayAttributes: displayAttributes, formType: pinFormType, service: service)
            let vc = SetPinViewController(viewModel: viewModel)
            vc.callback = completion
            push(vc)
            
        case let .verifyPin(pinFormType):
            let viewModel = VerifyPinViewModel(displayAttributes: displayAttributes, formType: pinFormType, service: service)
            let vc = VerifyPinViewController(viewModel: viewModel)
            vc.callback = completion
            push(vc)
            
        case let .changePin(pinFormType):
            let viewModel = ChangePinViewModel(displayAttributes: displayAttributes, formType: pinFormType, service: service)
            let vc = ChangePinViewController(viewModel: viewModel)
            vc.callback = completion
            push(vc)
        }
    }
}

