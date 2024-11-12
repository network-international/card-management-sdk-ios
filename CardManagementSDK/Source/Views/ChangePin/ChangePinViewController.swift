//
//  ChangePinViewController.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 24.10.2022.
//

import UIKit

class ChangePinViewController: UIViewController {
    
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: ChangePinViewModel
    private var oldPin: String?
    private var newPin: String?
    private var pinView: PinView?
    
    var callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    
    // MARK: - Init
    init(viewModel: ChangePinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ChangePinViewController", bundle: Bundle(for: ChangePinViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.titleText
        view.backgroundColor = viewModel.config.backgroundColor
        activityIndicator.style = .large
        
        pinView = PinView.fromBundle
        guard let pinView = pinView else { return }
        pinView.viewmodel = PinViewViewModel(dotsCount: viewModel.dotsCount,
                                             descriptionText: viewModel.config.enterCurrentPinText,
                                             fixedLength: viewModel.fixedLength)
        pinView.pinDelegate = self
        view.addSubview(pinView)
        view.bringSubviewToFront(activityIndicator)
        pinView.alignConstraintsToView(view: view)
    }
    
}


// MARK: - PinViewProtocol
extension ChangePinViewController: PinViewProtocol {
    func pinFilled(pin: String) {
        pinView?.disableButtons()
        
        if let oldPin = oldPin {
            if let newPin = newPin {
                if newPin == pin {
                    activityIndicator.startAnimating()
                    
                    DispatchQueue.global(qos: .default).async {
                        self.viewModel.changePin(oldPin: oldPin, newPin: newPin) { [weak self] sucess, error, callback in
                            guard let self = self else {
                                return
                            }
                            
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                            }
                            
                            self.callback?(sucess, error) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                } else {
                    pinView?.viewmodel?.descriptionText = viewModel.config.notMatchPinText
                    pinView?.resetView()
                }
            } else {
                newPin = pin
                guard let pinView = pinView else { return }
                pinView.viewmodel?.descriptionText = viewModel.config.reEnterNewPinText
                pinView.resetView()
            }
        } else {
            oldPin = pin
            guard let pinView = pinView else { return }
            pinView.viewmodel?.descriptionText = viewModel.config.enterNewPinText
            pinView.resetView()
        }
    }
}
