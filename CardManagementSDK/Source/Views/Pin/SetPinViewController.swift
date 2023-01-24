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
    
    var callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    
    // MARK: - Init
    init(viewModel: SetPinViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SetPinViewController", bundle: Bundle(for: SetPinViewController.self))
        
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
        title = "set_pin_title".localized
        
        pinView = Bundle(for: SetPinViewController.self).loadNibNamed("PinView", owner: self, options: nil)?.first as? PinView
        guard let pinView = pinView else { return }
        pinView.descriptionLabel.font = viewModel.font(for: .setPinDescriptionLabel)
        pinView.viewmodel = PinViewViewModel(theme: viewModel.theme,
                                             dotsCount: viewModel.dotsCount,
                                             descriptionText: "set_pin_description".localized,
                                             fixedLength: viewModel.fixedLength)
        pinView.pinDelegate = self
        view.addSubview(pinView)
        view.addSubview(activityIndicator)
        pinView.alignConstraintsToView(view: view)
    }
    
    // MARK: - Private
    private func updateUI(for theme: NITheme) {
        view.backgroundColor = theme == .light ? .white : UIColor.darkerGrayLight
    }
    
}


// MARK: - PinViewProtocol
extension SetPinViewController: PinViewProtocol {
    func pinFilled(pin: String) {
        pinView?.disableButtons()
        activityIndicator.startAnimating()

        DispatchQueue.main.async {
            self.viewModel.setPin(pin) { [weak self] success, error, callback in
                guard let self = self else {
                    return
                }
                self.activityIndicator.stopAnimating()
                self.pinView?.enableButtons()
                self.callback?(success, error) {
                    if (success != nil) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
