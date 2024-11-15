//
//  SetPinViewController.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 11.10.2022.
//

import UIKit

class SetPinViewController: UIViewController {
        
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: SetPinViewModel
    private var pinView: PinView?
    private var previousPin: String?
    
    var callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    
    /**
     func font(for label: UIElement.PinFormLabel) -> UIFont {
         displayAttributes?.fonts.font(for: label) ?? label.defaultFont
     }
     
     var theme: NITheme { /// default is light
         return displayAttributes?.theme ?? .light
     }
     */
    // MARK: - Init
    init(viewModel: SetPinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SetPinViewController", bundle: Bundle(for: SetPinViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.config.backgroundColor
        activityIndicator.style = .large
        title = viewModel.config.titleText
        
        pinView = PinView.fromBundle
        guard let pinView = pinView else { return }
        pinView.viewmodel = PinViewViewModel(dotsCount: viewModel.dotsCount,
                                             descriptionText: viewModel.config.enterPinText,
                                             fixedLength: viewModel.fixedLength)
        pinView.pinDelegate = self
        view.addSubview(pinView)
        view.bringSubviewToFront(activityIndicator)
        pinView.alignConstraintsToView(view: view)
    }
}


// MARK: - PinViewProtocol
extension SetPinViewController: PinViewProtocol {
    func pinFilled(pin: String) {
        pinView?.disableButtons()
        
        if let oldPin = previousPin {
            
            if oldPin == pin {
                activityIndicator.startAnimating()
                
                DispatchQueue.global(qos: .default).async {
                    self.viewModel.setPin(pin) { [weak self] success, error, callback in
                        guard let self = self else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                        }
                        
                        self.callback?(success, error) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            } else {
                pinView?.viewmodel?.descriptionText = viewModel.config.notMatchPinText
                pinView?.resetView()
            }
        } else {
            previousPin = pin
            guard let pinView = pinView else { return }
            pinView.viewmodel?.descriptionText = viewModel.config.reEnterPinText
            pinView.resetView()
        }
    }
}
