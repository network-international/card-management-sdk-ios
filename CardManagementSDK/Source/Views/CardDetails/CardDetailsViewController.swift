//
//  CardDetailsViewController.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 05.10.2022.
//

import UIKit

class CardDetailsViewController: UIViewController {
    
    @IBOutlet weak var customNICardView: NICardView!
    
    private var viewModel: CardDetailsViewModel
    
    
    // MARK: - Init
    init(viewModel: CardDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "CardDetailsViewController", bundle: Bundle(for: CardDetailsViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCloseButton()
        
        customNICardView.viewModel = viewModel
        customNICardView.activityIndicator.startAnimating()
        customNICardView.configureCardView()
    }
    
    // MARK: - Private
    private func setupCloseButton() {
        let closeButton = UIButton(type: .custom)
        let imageName = viewModel.input.displayAttributes?.theme == .light ? "icon_close" : "icon_close_white"
        let image = UIImage(named: imageName, in: Bundle.sdkBundle, compatibleWith: .none)
        closeButton.setImage(image, for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        let barCloseButton = UIBarButtonItem(customView: closeButton)
        self.navigationItem.rightBarButtonItem = barCloseButton

    }
    
    // MARK: - Actions
    @objc private func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
}
