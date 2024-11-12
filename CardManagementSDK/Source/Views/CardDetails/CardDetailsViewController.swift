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
    private var cardAttributes: NICardAttributes
    private var service: CardDetailsService
    private let cardBackground: UIImage?
    private let cardPositioning: NICardDetailsTextPositioning?
    
    // MARK: - Init
    init(
        title: String?,
        cardAttributes: NICardAttributes,
        cardBackground: UIImage?,
        cardPositioning: NICardDetailsTextPositioning?,
        service: CardDetailsService,
        callback: ((NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)?
    ) {
        self.cardAttributes = cardAttributes
        self.service = service
        self.callback = callback
        self.cardBackground = cardBackground
        self.cardPositioning = cardPositioning
        super.init(nibName: "CardDetailsViewController", bundle: Bundle(for: CardDetailsViewController.self))
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCloseButton()
        customNICardView.configure(
            cardAttributes: cardAttributes, 
            buttonsColor: .niAlwaysWhite,
            maskableValues: Set(UIElement.CardDetails.allCases),
            service: service
        ) { [weak self] errorResponse in
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
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(image, for: .normal)
        closeButton.tintColor = UIColor.label
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        let barCloseButton = UIBarButtonItem(customView: closeButton)
        self.navigationItem.rightBarButtonItem = barCloseButton
    }
    
    // MARK: - Actions
    @objc private func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
}
