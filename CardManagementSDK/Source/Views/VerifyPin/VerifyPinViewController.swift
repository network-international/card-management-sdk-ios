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
        super.init(nibName: "VerifyPinViewController", bundle: Bundle(for: Self.self))
        view.backgroundColor = viewModel.config.backgroundColor
        activityIndicator.style = .large
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.titleText
        
        pinView = PinView.fromBundle
        guard let pinView = pinView else { return }
        pinView.viewmodel = PinViewViewModel(dotsCount: viewModel.dotsCount,
                                             descriptionText: viewModel.config.descriptionAttributedText,
                                             fixedLength: viewModel.fixedLength)
        pinView.pinDelegate = self
        view.addSubview(pinView)
        view.bringSubviewToFront(activityIndicator)
        pinView.alignConstraintsToView(view: view)
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
