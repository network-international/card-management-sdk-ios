//
//  FormCoordinator.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 06.10.2022.
//

import Foundation

import UIKit

enum Route {
    case cardDetails(input: NIInput)
    case setPin(input: NIInput, type: NIPinFormType)
    case changePin(input: NIInput, type: NIPinFormType)
}

class FormCoordinator: NSObject, Coordinator {
    var navigationController: UIViewController
    var route: Route
    var completion: ((NISuccessResponse?, NIErrorResponse?) -> Void)?
    
    func start() {
        switch route {
        case .cardDetails(let input):
            let viewModel = makeCardDetailsViewModel(input: input)
            let vc = CardDetailsViewController(viewModel: viewModel)
            viewModel.callback = completion
            present(vc)
            
        case .setPin(let input, let type):
            let viewModel = makeSetPinViewModel(input: input, pinFormType: type)
            let vc = SetPinViewController(viewModel: viewModel)
            vc.callback = completion
            push(vc)
            
        case .changePin(let input, let type):
            let viewModel = makeChangePinViewModel(input: input, pinFormType: type)
            let vc = ChangePinViewController(viewModel: viewModel)
            vc.callback = completion
            push(vc)
        }
    }
    
    init(navigationController: UIViewController, route: Route, completion: ((NISuccessResponse?, NIErrorResponse?) -> Void)?) {
        self.navigationController = navigationController
        self.route = route
        self.completion = completion
    }
    
    
    // MARK: - Private
    private func makeCardDetailsViewModel(input: NIInput) -> CardDetailsViewModel {
        return CardDetailsViewModel(input: input)
    }
    
    private func makeSetPinViewModel(input: NIInput, pinFormType: NIPinFormType) -> SetPinViewModel {
        return SetPinViewModel(input: input, formType: pinFormType)
    }
    
    private func makeChangePinViewModel(input: NIInput, pinFormType: NIPinFormType) -> ChangePinViewModel {
        return ChangePinViewModel(input: input, formType: pinFormType)
    }
}

