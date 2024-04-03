//
//  CardDetailsViewController.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 05.10.2022.
//

import UIKit

class CardDetailsViewController: UIViewController {
    
    @IBOutlet weak var customNICardView: NICardView!
    
    private var callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    private var displayAttributes: NIDisplayAttributes
    private var service: CardDetailsService
    
    // MARK: - Init
    init(displayAttributes: NIDisplayAttributes = .default, service: CardDetailsService, callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?) {
        self.displayAttributes = displayAttributes
        self.service = service
        self.callback = callback
        super.init(nibName: "CardDetailsViewController", bundle: Bundle(for: CardDetailsViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "card_details_title".localized
        setupCloseButton()
        customNICardView.configure(displayAttributes: displayAttributes, service: service) { [weak self] errorResponse in
            self?.callback?(
                errorResponse == nil ? NISuccessResponse(message: "Card details retrieved with success!") : nil,
                errorResponse
            ){}
        }
    }
    
    // MARK: - Private
    private func setupCloseButton() {
        let closeButton = UIButton(type: .custom)
        let image = UIImage(
            named: (displayAttributes.theme == .light) ? "icon_close" : "icon_close_white",
            in: Bundle.sdkBundle,
            compatibleWith: .none
        )
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
