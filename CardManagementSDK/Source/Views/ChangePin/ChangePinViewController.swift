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
    private var previousPin: String?
    private var pinView: PinView?
    
    var callback: ((NISuccessResponse?, NIErrorResponse?) -> Void)?
    
    // MARK: - Init
    init(viewModel: ChangePinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ChangePinViewController", bundle: Bundle(for: ChangePinViewController.self))
        
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
        title = "change_pin_title".localized
        
        pinView = Bundle(for: ChangePinViewController.self).loadNibNamed("PinView", owner: self, options: nil)?.first as? PinView
        guard let pinView = pinView else { return }
        pinView.descriptionLabel.font = viewModel.font(for: .changePinDescriptionLabel)
        pinView.viewmodel = PinViewViewModel(theme: viewModel.theme,
                                             dotsCount: viewModel.dotsCount,
                                             descriptionText: "change_pin_description_step1".localized,
                                             fixedLength: viewModel.fixedLength)
        pinView.pinDelegate = self
        view.addSubview(pinView)
        pinView.alignConstraintsToView(view: view)
    }
    
    // MARK: - Private
    private func updateUI(for theme: NITheme) {
        view.backgroundColor = theme == .light ? .white : UIColor.darkerGrayLight
    }
    
}


// MARK: - PinViewProtocol
extension ChangePinViewController: PinViewProtocol {
    func pinFilled(pin: String) {
        pinView?.disableButtons()
        
        if let oldPin = previousPin {
            activityIndicator.startAnimating()
            viewModel.changePin(oldPin: oldPin, newPin: pin) { [weak self] response, err in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.callback?(response, err)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            previousPin = pin
            guard let pinView = pinView else { return }
            pinView.viewmodel?.descriptionText = "change_pin_description_step2".localized
            pinView.resetView()
        }
    }
}
