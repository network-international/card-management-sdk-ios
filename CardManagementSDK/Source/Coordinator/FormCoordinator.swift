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
    private let displayAttributes: NIDisplayAttributes?
    
    private var coordinateCompletion: ((NIErrorResponse?) -> Void)?
    
    init(navigationController: UIViewController, displayAttributes: NIDisplayAttributes?, service: FormCoordinatorService) {
        self.navigationController = navigationController
        self.displayAttributes = displayAttributes
        self.service = service
    }
    
    func coordinate(route: Route, completion: @escaping (NIErrorResponse?) -> Void) {
        self.coordinateCompletion = completion
        switch route {
        case .cardDetails:
            let viewModel = CardDetailsViewModel(displayAttributes: displayAttributes, service: service)
            let vc = CardDetailsViewController(viewModel: viewModel)
            vc.delegate = self
            present(vc)
            
        case let .setPin(pinFormType):
            let viewModel = SetPinViewModel(displayAttributes: displayAttributes, formType: pinFormType, service: service)
            let vc = SetPinViewController(viewModel: viewModel)
            vc.delegate = self
            push(vc)
            
        case let .verifyPin(pinFormType):
            let viewModel = VerifyPinViewModel(displayAttributes: displayAttributes, formType: pinFormType, service: service)
            let vc = VerifyPinViewController(viewModel: viewModel)
            vc.delegate = self
            push(vc)
            
        case let .changePin(pinFormType):
            let viewModel = ChangePinViewModel(displayAttributes: displayAttributes, formType: pinFormType, service: service)
            let vc = ChangePinViewController(viewModel: viewModel)
            vc.delegate = self
            push(vc)
        }
    }
}

extension FormCoordinator: VerifyPinViewDelegate, ChangePinViewDelegate, SetPinViewDelegate, CardDetailsViewDelegate {
    // MARK: - VerifyPinViewDelegate
    func verifyPinView(_ vc: VerifyPinViewController, didCompleteWith error: NIErrorResponse?) {
        vc.navigationController?.popViewController(animated: true)
        // animation completion
        DispatchQueue.main.async {
            self.coordinateCompletion?(error)
        }
    }
    // MARK: - ChangePinViewDelegate
    func changePinView(_ view: ChangePinViewController, didChangePinWith error: NIErrorResponse?) {
        view.navigationController?.popViewController(animated: true)
        // animation completion
        DispatchQueue.main.async {
            self.coordinateCompletion?(error)
        }
    }
    // MARK: - SetPinViewDelegate
    func setPinView(_ vc: SetPinViewController, didCompleteWith error: NIErrorResponse?) {
        vc.navigationController?.popViewController(animated: true)
        // animation completion
        DispatchQueue.main.async {
            self.coordinateCompletion?(error)
        }
    }
    
    // MARK: - CardDetailsViewDelegate
    func cardDetailsView(_ vc: CardDetailsViewController, didCompleteWith error: NIErrorResponse?) {
        coordinateCompletion?(error)
    }
    func cardDetailsViewDidClose(_ vc: CardDetailsViewController) {
        vc.dismiss(animated: true)
    }
}
