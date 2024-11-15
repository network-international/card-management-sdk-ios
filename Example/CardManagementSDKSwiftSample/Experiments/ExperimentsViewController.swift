//
//  ExperimentsViewController.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 01.03.2024.
//

import UIKit
import NICardManagementSDK
import Combine

class ExperimentsViewController: UIViewController {

    private let viewModel: ExperimentsViewModel
    private var bag = Set<AnyCancellable>()
    private let stackView = UIStackView()
    private let logo: LogoView
    
    private var sdk: NICardManagementAPI
    
    private lazy var cardViewCallback: (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void = { [weak self] successResponse, errorResponse, callback  in
        print("Success Response \(successResponse?.message ?? "-"); \nError code: \(errorResponse?.errorCode ?? "-"), Error message: \(errorResponse?.errorMessage ?? "-")")
        guard let error = errorResponse else { return }
        let alert = UIAlertController(title: "Fail", message: error.errorMessage, preferredStyle: .alert)
        
        if let attributedString = try? NSAttributedString(data: Data(error.errorMessage.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            alert.title = nil
            alert.setValue(attributedString, forKey: "attributedMessage")
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        (self?.presentedViewController ?? self)?.present(alert, animated: true)
    }
    
    init(viewModel: ExperimentsViewModel) {
        self.viewModel = viewModel
        logo = LogoView(isArabic: false)
        sdk = viewModel.settingsProvider.settings.buildSdk()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.settingsProvider.$settings
            .receive(on: RunLoop.main)
            .sink { [weak self] settings in
                self?.sdk = settings.buildSdk()
                // refresh UI
                self?.fillContent()
            }
            .store(in: &bag)
    }
}

private extension ExperimentsViewController {
    func setupView() {
        view.addSubview(logo)
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            logo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: logo.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
    }
    
    func fillContent() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // show card
        stackView.addArrangedSubview(makeButton(
            title: "Present form with card",
            action: UIAction { [weak self] _ in
                guard let self = self else { return }
                self.sdk.displayCardDetailsForm(
                    viewController: self,
                    cardAttributes: self.viewModel.cardAttributes,
                    cardViewBackground: self.viewModel.backgroundImage,
                    cardViewTextPositioning: self.viewModel.textPositioning,
                    completion: self.cardViewCallback
                )
            }
        ))
        
        // show presenter
        stackView.addArrangedSubview(makeButton(
            title: "Use card elements",
            action: UIAction { [weak self] _ in
                guard let self = self else { return }
                self.showCardDatailsPresenter()
            }
        ))
    }
    
    func makeButton(title: String?, action: UIAction?) -> UIView {
        let button = UIButton(type: .system, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(resource: .niBlue)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }
    
    func makeHeader(_ text: String) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        label.text = text
        return view
    }
    
    func showCardDatailsPresenter() {
        let alertController = UIAlertController(title: "Card elements", message: nil, preferredStyle: .actionSheet)
        
        // toggle cardPresenter.isMasked (the way how information displayed) 
        // - by `displayAttributes.cardAttributes.shouldHide`
        let cardPresenter = sdk.buildCardDetailsPresenter(cardAttributes: viewModel.cardAttributes)
        let customView = UIStackView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.axis = .vertical
        customView.spacing = 10
        // card number line
        let copyCardNumberBtn = UIButton(primaryAction: UIAction(
            image: UIImage(systemName: "square.and.arrow.up.circle"),
            handler: { [cardPresenter] _ in
                let template = """
                cardNumber: %@
                cvv: %@
                expiry: %@
                """
                cardPresenter.copyToClipboard([.cardNumber, .cvv, .expiry], template: template)
            }
        ))
        let maskCardNumberBtn = UIButton(primaryAction: UIAction(
            image: UIImage(systemName: "eye.slash"),
            handler: { [cardPresenter] _ in
                var maskedElements = cardPresenter.maskedElements
                if cardPresenter.isMasked(.cardNumber) {
                    maskedElements.remove(.cardNumber)
                } else {
                    maskedElements.insert(.cardNumber)
                }
                cardPresenter.toggle(isMasked: maskedElements)
            }
        ))
        let cardNumberLine = UIStackView(arrangedSubviews: [
            cardPresenter.cardNumber.title,
            UIView(),
            cardPresenter.cardNumber.value,
            copyCardNumberBtn,
            maskCardNumberBtn
        ])
        cardNumberLine.axis = .horizontal
        cardNumberLine.spacing = 10
        cardNumberLine.distribution = .fill
        customView.addArrangedSubview(cardNumberLine)
        
        // cvv line
        let copyCvvBtn = UIButton(primaryAction: UIAction(
            image: UIImage(systemName: "square.and.arrow.up.circle"),
            handler: { [cardPresenter] _ in
                cardPresenter.copyToClipboard([.cvv])
            }
        ))
        let maskCvvBtn = UIButton(primaryAction: UIAction(
            image: UIImage(systemName: "eye.slash"),
            handler: { [cardPresenter] _ in
                var maskedElements = cardPresenter.maskedElements
                if cardPresenter.isMasked(.cvv) {
                    maskedElements.remove(.cvv)
                } else {
                    maskedElements.insert(.cvv)
                }
                cardPresenter.toggle(isMasked: maskedElements)
            }
        ))
        let cvvLine = UIStackView(arrangedSubviews: [
            cardPresenter.cardCvv.title,
            UIView(),
            cardPresenter.cardCvv.value,
            copyCvvBtn,
            maskCvvBtn
        ])
        cvvLine.axis = .horizontal
        cvvLine.spacing = 10
        customView.addArrangedSubview(cvvLine)
        
        customView.addArrangedSubview(cardPresenter.cardExpiry.title)
        customView.addArrangedSubview(cardPresenter.cardExpiry.value)
        customView.addArrangedSubview(cardPresenter.cardHolder.title)
        customView.addArrangedSubview(cardPresenter.cardHolder.value)
        let maskAllBtn = UIButton(primaryAction: UIAction(
            title: "Toggle Masking All",
            image: UIImage(systemName: "eye.slash"),
            handler: { [cardPresenter] _ in
                cardPresenter.toggle(isMasked: cardPresenter.maskedElements.isEmpty ? Set(UIElement.CardDetails.allCases) : Set())
            }
        ))
        customView.addArrangedSubview(maskAllBtn)
        
        let activity = UIActivityIndicatorView(style: .large)
        activity.startAnimating()
        activity.hidesWhenStopped = true
        customView.addArrangedSubview(activity)
        cardPresenter.showCardDetails { [customView, activity] errorResponse in
            activity.stopAnimating()
            let additionalLabel = UILabel()
            additionalLabel.translatesAutoresizingMaskIntoConstraints = false
            if let errorMessage = errorResponse?.errorMessage {
                additionalLabel.text = errorMessage
            } else {
                additionalLabel.text = "Card details fetched!"
            }
            customView.addArrangedSubview(additionalLabel)
        }
        
        alertController.view.addSubview(customView)
        
        customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
        customView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -10).isActive = true
        customView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 10).isActive = true

        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: 430).isActive = true

        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

private extension ExperimentsViewModel {

    var textPositioning: NICardDetailsTextPositioning? { settingsProvider.textPosition.sdkValue
    }
    var backgroundImage: UIImage? { settingsProvider.cardBackgroundImage }
    
    var cardAttributes: NICardAttributes {
        // Example how fonts, colors can be changed
        NICardAttributes(
            shouldBeMaskedDefault: Set([.cvv]),
            labels: [
                .cardNumber: NSAttributedString(
                    string: "My card >>",
                    attributes: [
                        .font : UIElement.CardDetails.cardNumber.defaultLabelFont,
                        .foregroundColor: UIColor.red
                    ]
                ),
                .cvv: NSAttributedString(
                    string: "My CVV >>",
                    attributes: [
                        .font : UIElement.CardDetails.cvv.defaultLabelFont,
                        .foregroundColor: UIColor.blue
                    ]
                ),
                .cardHolder: NICardAttributes.zero.labels[.cardHolder]!,
                .expiry: NICardAttributes.zero.labels[.expiry]!,
            ],
            valueAttributes: [
                .cardNumber: [
                    .font : UIElement.CardDetails.cardNumber.defaultValueFont,
                    .foregroundColor: UIColor.purple
                ],
                .cvv: [
                    .font : UIElement.CardDetails.cvv.defaultValueFont,
                    .foregroundColor: UIColor.green
                ],
                .cardHolder: NICardAttributes.zero.valueAttributes[.cardHolder]!,
                .expiry: NICardAttributes.zero.valueAttributes[.expiry]!,
            ]
        )
    }
}
