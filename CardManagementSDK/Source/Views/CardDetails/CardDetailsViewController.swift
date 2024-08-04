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
    private let language: NILanguage?
    private let cardBackground: UIImage?
    private let cardPositioning: NICardDetailsTextPositioning?
    
    // MARK: - Init
    init(
        language: NILanguage?,
        displayAttributes: NIDisplayAttributes = .zero,
        cardBackground: UIImage?,
        cardPositioning: NICardDetailsTextPositioning?,
        service: CardDetailsService,
        callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    ) {
        self.language = language
        self.displayAttributes = displayAttributes
        self.service = service
        self.callback = callback
        self.cardBackground = cardBackground
        self.cardPositioning = cardPositioning
        super.init(nibName: "CardDetailsViewController", bundle: Bundle(for: CardDetailsViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NIResource.L10n.cardDetailsTitleKey.localized(with: language)
        setupCloseButton()
        customNICardView.configure(language: language, displayAttributes: displayAttributes, maskableValues: Set(UIElement.CardDetails.Value.allCases), service: service) { [weak self] errorResponse in
            self?.callback?(
                errorResponse == nil ? NISuccessResponse(message: "Card details retrieved with success!") : nil,
                errorResponse
            ){}
        }
        customNICardView.setBackgroundImage(image: cardBackground)
        customNICardView.updatePositioning(cardPositioning)
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
