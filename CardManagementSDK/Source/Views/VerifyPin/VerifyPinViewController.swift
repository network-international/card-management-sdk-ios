//
//  VerifyPinViewController.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 04.04.2023.
//

import UIKit

protocol VerifyPinViewDelegate: AnyObject {
    func verifyPinView(_ vc: VerifyPinViewController, didCompleteWith error: NIErrorResponse?)
}

class VerifyPinViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel: VerifyPinViewModel
    private var pinView: PinView?
    
    weak var delegate: VerifyPinViewDelegate?
    
    // MARK: - Init
    init(viewModel: VerifyPinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "VerifyPinViewController", bundle: Bundle(for: VerifyPinViewController.self))
        
        // theme (dark / light mode setups)
        updateUI(for: viewModel.theme)
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
extension VerifyPinViewController: PinViewProtocol {
    func pinFilled(pin: String) {
        pinView?.disableButtons()
        activityIndicator.startAnimating()

        Task {
            var resultError: Error?
            do {
                try await viewModel.verifyPin(pin)
            } catch {
                resultError = error
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.delegate?.verifyPinView(
                    self,
                    didCompleteWith: (resultError as? NISDKError).flatMap { NIErrorResponse(error: $0) }
                )
            }
        }
    }
}
