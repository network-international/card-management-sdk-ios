//
//  CardViewController.swift
//  CardManagementSDKSwiftSample
//
//  Created by Paula Radu on 25.11.2022.
//

import UIKit
import NICardManagementSDK
import Combine

class CardViewController: UIViewController {
    private let viewModel: CardViewModel
    private var bag = Set<AnyCancellable>()
    private let stackView = UIStackView()
    private let logo: LogoView
    private let pinViewHolder = UIView()
    private let cardViewHolder = UIView()
    
    private var sdk: NICardManagementAPI
    
    private lazy var cardViewCallback: (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void = { [weak self] successResponse, errorResponse, callback  in
        print("Success Response \(successResponse?.message ?? "-"); \nError code: \(errorResponse?.errorCode ?? "-"), Error message: \(errorResponse?.errorMessage ?? "-")")
        self?.presentedViewController?.dismiss(animated: true)
        guard let error = errorResponse else { return }
        let alert = UIAlertController(title: "Fail", message: error.errorMessage, preferredStyle: .alert)
        
        if let attributedString = try? NSAttributedString(data: Data(error.errorMessage.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            alert.title = nil
            alert.setValue(attributedString, forKey: "attributedMessage")
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self?.present(alert, animated: true)
    }
    
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
        logo = LogoView(currentLanguage: viewModel.settingsProvider.currentLanguage)
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
        viewModel.settingsProvider.$currentLanguage
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.logo.update(with: $0) }
            .store(in: &bag)
    }
}

private extension CardViewController {
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
        
        cardViewHolder.layer.masksToBounds = true
        cardViewHolder.layer.cornerRadius = 20
        cardViewHolder.layer.borderWidth = 1
        cardViewHolder.layer.borderColor = UIColor.white.cgColor
        
        let cardBgImage = UIImageView(image: UIImage(resource: .background))
        cardBgImage.translatesAutoresizingMaskIntoConstraints = false
        cardViewHolder.addSubview(cardBgImage)
        NSLayoutConstraint.activate([
            cardBgImage.leadingAnchor.constraint(equalTo: cardViewHolder.leadingAnchor),
            cardBgImage.trailingAnchor.constraint(equalTo: cardViewHolder.trailingAnchor),
            cardBgImage.topAnchor.constraint(equalTo: cardViewHolder.topAnchor),
            cardBgImage.bottomAnchor.constraint(equalTo: cardViewHolder.bottomAnchor)
        ])
        cardViewHolder.heightAnchor.constraint(equalToConstant: 182).isActive = true
        cardViewHolder.translatesAutoresizingMaskIntoConstraints = false
        
        let pinBgImage = UIImageView(image: UIImage(resource: .background))
        pinBgImage.translatesAutoresizingMaskIntoConstraints = false
        pinBgImage.alpha = 0.5
        pinViewHolder.addSubview(pinBgImage)
        NSLayoutConstraint.activate([
            pinBgImage.leadingAnchor.constraint(equalTo: pinViewHolder.leadingAnchor),
            pinBgImage.trailingAnchor.constraint(equalTo: pinViewHolder.trailingAnchor),
            pinBgImage.topAnchor.constraint(equalTo: pinViewHolder.topAnchor),
            pinBgImage.bottomAnchor.constraint(equalTo: pinViewHolder.bottomAnchor)
        ])
        pinViewHolder.heightAnchor.constraint(equalToConstant: 60).isActive = true
        pinViewHolder.translatesAutoresizingMaskIntoConstraints = false
        pinViewHolder.layer.masksToBounds = true
        pinViewHolder.layer.cornerRadius = 15
        pinViewHolder.layer.borderWidth = 1
        pinViewHolder.layer.borderColor = UIColor.white.cgColor
    }
    
    func fillContent() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(cardViewHolder)
        
        let cardViewCompletion: (NIErrorResponse?) -> Void = { [weak self] errorResp in
            self?.cardViewCallback(
                errorResp == nil ? NISuccessResponse(message: "Card details retrieved with success!") : nil,
                errorResp
            ){}
        }
        // show card
        stackView.addArrangedSubview(makeButton(
            title: "Show card details",
            action: UIAction { [weak self] _ in
                guard let self = self else { return }
                // for presenting new CardViewController
                // sdk.displayCardDetailsForm(viewController: self, completion: cardViewCallback)
                
                // for retrieving info only
                // sdk.getCardDetails(completion: cardViewCallback)
                
                // show in-place
                if let cardView = self.cardViewHolder.subviews.last as? NICardView {
                    cardView.configure(displayAttributes: self.viewModel.displayAttributes, maskableValues: Set(UIElement.CardDetails.Value.allCases), service: sdk, completion: cardViewCompletion)
                    // this can be done with `cardAttributes`
                    // cardView.setBackgroundImage(image: viewModel.settingsProvider.cardBackgroundImage)
                } else {
                    // card
                    let cardView = NICardView()
                    self.cardViewHolder.addSubview(cardView)
                    cardView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        cardView.topAnchor.constraint(equalTo: self.cardViewHolder.topAnchor),
                        cardView.bottomAnchor.constraint(equalTo: self.cardViewHolder.bottomAnchor),
                        cardView.leadingAnchor.constraint(equalTo: self.cardViewHolder.leadingAnchor),
                        cardView.trailingAnchor.constraint(equalTo: self.cardViewHolder.trailingAnchor)
                    ])
                    cardView.configure(displayAttributes: self.viewModel.displayAttributes, maskableValues: Set(UIElement.CardDetails.Value.allCases), service: sdk, completion: cardViewCompletion)
                }
            }
        ))
        
        stackView.addArrangedSubview(makeHeader("PIN Management"))
        
        stackView.addArrangedSubview(makeButton(
            title: "Set PIN",
            action: UIAction { [weak self] _ in
                guard let self = self else { return }
                /// Uncomment below section for programatic flow
//                self.sdk.setPin(pin: "1111", completion: self.cardViewCallback)
//                return
                
                let pinType = self.viewModel.settingsProvider.settings.pinType
                // current implementation expecting UINavigationController
                // and will push form there
                let dummyVC = UIViewController()
                let navVC = UINavigationController(rootViewController: dummyVC)
                navVC.isNavigationBarHidden = true
                self.sdk.setPinForm(type: pinType, viewController: dummyVC, displayAttributes: self.viewModel.displayAttributes, completion: self.cardViewCallback)
                self.present(navVC, animated: true)
            }
        ))
        
        stackView.addArrangedSubview(makeButton(
            title: "Change PIN",
            action: UIAction { [weak self] _ in
                guard let self = self else { return }
                // Uncomment below section for programatic flow
//                self.sdk.changePin(oldPin: "1111", newPin: "5555", completion: self.cardViewCallback)
//                return
                
                let pinType = self.viewModel.settingsProvider.settings.pinType
                // current implementation expecting UINavigationController
                // and will push form there
                let dummyVC = UIViewController()
                let navVC = UINavigationController(rootViewController: dummyVC)
                navVC.isNavigationBarHidden = true
                self.sdk.changePinForm(type: pinType, viewController: dummyVC, displayAttributes: self.viewModel.displayAttributes, completion: cardViewCallback)
                self.present(navVC, animated: true)
            }
        ))
        
        stackView.addArrangedSubview(makeButton(
            title: "Verify PIN",
            action: UIAction { [weak self] _ in
                guard let self = self else { return }
                // Uncomment below section for programatic flow
                // NICardManagementAPI.verifyPin(pin: "4321", input: self.cardViewInput, completion: cardViewCallback)
                // return
                
                let pinType = self.viewModel.settingsProvider.settings.pinType
                // current implementation expecting UINavigationController
                // and will push form there
                let dummyVC = UIViewController()
                let navVC = UINavigationController(rootViewController: dummyVC)
                navVC.isNavigationBarHidden = true

                self.sdk.verifyPinForm(type: pinType, viewController: dummyVC, displayAttributes: self.viewModel.displayAttributes, completion: cardViewCallback)
                self.present(navVC, animated: true)
            }
        ))
        
        stackView.addArrangedSubview(makeButton(
            title: "View PIN",
            action: UIAction { [weak self] _ in
                guard let self = self else { return }
                // Uncomment below section for programatic flow
                // NICardManagementAPI.getPin(input: self.cardViewInput, completion: cardViewCallback)
                // return
                let timer: Double = 5
                let color: UIColor = .gray
                // show in-place
                if let pinView = self.pinViewHolder.subviews.last as? NIViewPinView {
                    pinView.configure(displayAttributes: self.viewModel.displayAttributes, service: self.sdk, timer: timer, color: color, completion: cardViewCallback)
                } else {
                    let pinView = NIViewPinView(displayAttributes: self.viewModel.displayAttributes, service: self.sdk, timer: timer, color: color, completion: cardViewCallback)
                    self.pinViewHolder.addSubview(pinView)
                    pinView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        pinView.topAnchor.constraint(equalTo: self.pinViewHolder.topAnchor),
                        pinView.bottomAnchor.constraint(equalTo: self.pinViewHolder.bottomAnchor),
                        pinView.leadingAnchor.constraint(equalTo: self.pinViewHolder.leadingAnchor),
                        pinView.trailingAnchor.constraint(equalTo: self.pinViewHolder.trailingAnchor)
                    ])
                    
                }
            }
        ))
        
        stackView.addArrangedSubview(pinViewHolder)
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
}

private extension CardViewModel {
    var displayAttributes: NIDisplayAttributes {
        NIDisplayAttributes(
            theme: settingsProvider.theme,
            language: settingsProvider.currentLanguage, // can be nil
            fonts: settingsProvider.fonts, // can be omitted
            cardAttributes: cardAttributes // can be nil
        )
    }
    
    var cardAttributes: NICardAttributes {
        NICardAttributes(
            shouldBeMaskedDefault: Set(UIElement.CardDetails.Value.allCases),
            backgroundImage: settingsProvider.cardBackgroundImage,
            textPositioning: settingsProvider.textPosition.sdkValue
        )
    }
}
