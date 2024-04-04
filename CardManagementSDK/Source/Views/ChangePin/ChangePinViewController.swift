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
        
        // theme (dark / light mode setups)
        updateUI(for: viewModel.theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NIResource.L10n.changePinTitleKey.localized
        
        pinView = Bundle(for: ChangePinViewController.self).loadNibNamed("PinView", owner: self, options: nil)?.first as? PinView
        guard let pinView = pinView else { return }
        pinView.descriptionLabel.font = viewModel.font(for: .changePinDescription)
        pinView.viewmodel = PinViewViewModel(theme: viewModel.theme,
                                             dotsCount: viewModel.dotsCount,
                                             descriptionText: NIResource.L10n.changePinEnterCurrentKey.localized,
                                             fixedLength: viewModel.fixedLength)
        pinView.pinDelegate = self
        view.addSubview(pinView)
        view.bringSubviewToFront(activityIndicator)
        pinView.alignConstraintsToView(view: view)
    }
    
    // MARK: - Private
    private func updateUI(for theme: NITheme) {
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.backgroundColor
            view.overrideUserInterfaceStyle = viewModel.theme == .light ? .light : .dark
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .whiteLarge
            activityIndicator.color = theme == .light ? .gray : .white
            view.backgroundColor = theme == .light ? .white : .black
        }
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
                    pinView?.viewmodel?.descriptionText = NIResource.L10n.changePinNotMatchKey.localized
                    pinView?.resetView()
                }
            } else {
                newPin = pin
                guard let pinView = pinView else { return }
                pinView.viewmodel?.descriptionText = NIResource.L10n.changePinReenterPinKey.localized
                pinView.resetView()
            }
        } else {
            oldPin = pin
            guard let pinView = pinView else { return }
            pinView.viewmodel?.descriptionText = NIResource.L10n.changePinEnterNewPinKey.localized
            pinView.resetView()
        }
    }
}
