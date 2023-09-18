//
//  VerifyPinViewController.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 04.04.2023.
//

import UIKit

class VerifyPinViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: VerifyPinViewModel
    private var pinView: PinView?
    
    var callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    
    // MARK: - Init
    init(viewModel: VerifyPinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "VerifyPinViewController", bundle: Bundle(for: VerifyPinViewController.self))
        
        // theme (dark / light mode setups)
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.backgroundColor
            self.view.overrideUserInterfaceStyle = viewModel.theme == .light ? .light : .dark
        } else {
            /// Fallback on earlier versions
            updateUI(for: viewModel.theme)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "verify_pin_title".localized
        
        pinView = Bundle(for: VerifyPinViewController.self).loadNibNamed("PinView", owner: self, options: nil)?.first as? PinView
        guard let pinView = pinView else { return }
        pinView.descriptionLabel.font = viewModel.font(for: .verifyPinDescriptionLabel)
        pinView.viewmodel = PinViewViewModel(theme: viewModel.theme,
                                             dotsCount: viewModel.dotsCount,
                                             descriptionText: "verify_pin_description".localized,
                                             fixedLength: viewModel.fixedLength)
        pinView.pinDelegate = self
        view.addSubview(pinView)
        view.bringSubviewToFront(activityIndicator)
        pinView.alignConstraintsToView(view: view)
    }
    
    // MARK: - Private
    private func updateUI(for theme: NITheme) {
        view.backgroundColor = theme == .light ? .white : UIColor.black
    }
    
}


// MARK: - PinViewProtocol
extension VerifyPinViewController: PinViewProtocol {
    func pinFilled(pin: String) {
        pinView?.disableButtons()
        activityIndicator.startAnimating()

        DispatchQueue.global(qos: .default).async {
            self.viewModel.verifyPin(pin) { [weak self] success, error, callback in
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
    }
}
