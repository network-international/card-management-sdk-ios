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
    
    // MARK: - Init
    init(viewModel: SetPinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SetPinViewController", bundle: Bundle(for: SetPinViewController.self))
        
        // theme (dark / light mode setups)
        updateUI(for: viewModel.theme)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NIResource.L10n.setPinTitleKey.localized
        
        pinView = Bundle(for: SetPinViewController.self).loadNibNamed("PinView", owner: self, options: nil)?.first as? PinView
        guard let pinView = pinView else { return }
        pinView.descriptionLabel.font = viewModel.font(for: .setPinDescription)
        pinView.viewmodel = PinViewViewModel(theme: viewModel.theme,
                                             dotsCount: viewModel.dotsCount,
                                             descriptionText: NIResource.L10n.setPinEnterKey.localized,
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
                pinView?.viewmodel?.descriptionText = NIResource.L10n.setPinNotMatchKey.localized
                pinView?.resetView()
            }
        } else {
            previousPin = pin
            guard let pinView = pinView else { return }
            pinView.viewmodel?.descriptionText = NIResource.L10n.setPinReenterPinKey.localized
            pinView.resetView()
        }
    }
}
