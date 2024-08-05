//
//  NICardView.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 24.11.2022.
//

import UIKit

public final class NICardView: UIView {
    private lazy var cardNrCopyButton: UIButton = { // copyButton
        let element = UIButton()
        element.translatesAutoresizingMaskIntoConstraints = false
        let image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "rectangle.portrait.on.rectangle.portrait")
        } else {
            image = UIImage(named: "icon_copy", in: Bundle.sdkBundle, compatibleWith: .none)
        }
        element.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        element.addTarget(self, action: #selector(cardNrCopyAction), for: .touchUpInside)
        return element
    }()
    private lazy var eyeButton: EyeButton = {
        let element = EyeButton()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.addTarget(self, action: #selector(eyeButtonAction(_:)), for: .touchUpInside)
        element.widthAnchor.constraint(equalToConstant: Constants.eyeImageSize.width).isActive = true
        element.heightAnchor.constraint(equalToConstant: Constants.eyeImageSize.height).isActive = true
        return element
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let element = UIActivityIndicatorView()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.hidesWhenStopped = true
        element.tintColor = .white
        if #available(iOS 13.0, *) {
            element.style = .large
        } else {
            element.style = .whiteLarge
        }
        return element
    }()
    private lazy var backgroundCardImage: UIImageView = {
        let element = UIImageView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var nameCopyButton: UIButton = {
        let element = UIButton()
        element.translatesAutoresizingMaskIntoConstraints = false
        let image: UIImage?
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "rectangle.portrait.on.rectangle.portrait")
        } else {
            image = UIImage(named: "icon_copy", in: Bundle.sdkBundle, compatibleWith: .none)
        }
        element.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        element.addTarget(self, action: #selector(nameCopyAction), for: .touchUpInside)
        return element
    }()
    
    private var leftAlignmentConstraint: NSLayoutConstraint?
    private var cardNumberGroupTopConstraint: NSLayoutConstraint?
    private var dateCvvGroupTopConstraint: NSLayoutConstraint?
    private var holderNameTopConstraint: NSLayoutConstraint?

    private var presenter = NICardElementsPresenter()
    
    private var maskableValues = Set(UIElement.CardDetails.Value.allCases)
    
    override public init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.cornerRadius = 20
        semanticContentAttribute = .forceLeftToRight
        /**
         =================================
         ||
         ||
         ||     c number
         ||     1234            􀽰
         ||
         ||     date            cvv     􀋭                  􀇲[loading indicator]
         ||     11 / 23         234
         ||
         ||     name
         ||     Card Holder
         ||
         =================================
         */
        // cardNrGroup
        let cardGr = UIStackView(arrangedSubviews: [presenter.cardNumber.title, presenter.cardNumber.value])
        cardGr.translatesAutoresizingMaskIntoConstraints = false
        cardGr.axis = .vertical
        cardGr.spacing = 0
        let cardCopyGr = UIStackView(arrangedSubviews: [UIView(), cardNrCopyButton])
        cardCopyGr.translatesAutoresizingMaskIntoConstraints = false
        cardCopyGr.axis = .vertical
        cardCopyGr.alignment = .trailing
        let cardNrGroup = UIStackView(arrangedSubviews: [cardGr, cardCopyGr])
        cardNrGroup.axis = .horizontal
        cardNrGroup.spacing = Constants.copyButtonHSpace
        cardNrGroup.translatesAutoresizingMaskIntoConstraints = false
        
        // date cvv group
        let dateGr = UIStackView(arrangedSubviews: [presenter.cardExpiry.title, presenter.cardExpiry.value])
        dateGr.translatesAutoresizingMaskIntoConstraints = false
        dateGr.axis = .vertical
        dateGr.spacing = 0
        let cvvGr = UIStackView(arrangedSubviews: [presenter.cardCvv.title, presenter.cardCvv.value])
        cvvGr.translatesAutoresizingMaskIntoConstraints = false
        cvvGr.axis = .vertical
        cvvGr.spacing = 0
        let eyeGr = UIStackView(arrangedSubviews: [eyeButton, UIView()])
        eyeGr.translatesAutoresizingMaskIntoConstraints = false
        eyeGr.axis = .vertical
        eyeGr.alignment = .trailing
        let dateCvvGroup = UIStackView(arrangedSubviews: [dateGr, cvvGr, eyeGr])
        dateCvvGroup.axis = .horizontal
        dateCvvGroup.spacing = Constants.dateCvvHSpace
        dateCvvGroup.translatesAutoresizingMaskIntoConstraints = false
        
        // card holder group
        let cardHolderGr = UIStackView(arrangedSubviews: [presenter.cardHolder.title, presenter.cardHolder.value])
        cardHolderGr.translatesAutoresizingMaskIntoConstraints = false
        cardHolderGr.axis = .vertical
        cardHolderGr.spacing = 0
        let cardHolderCopyGr = UIStackView(arrangedSubviews: [UIView(), nameCopyButton])
        cardHolderCopyGr.translatesAutoresizingMaskIntoConstraints = false
        cardHolderCopyGr.axis = .vertical
        cardHolderCopyGr.alignment = .trailing
        let cardNameWithCopyGr = UIStackView(arrangedSubviews: [cardHolderGr, cardHolderCopyGr])
        cardNameWithCopyGr.axis = .horizontal
        cardNameWithCopyGr.spacing = Constants.copyButtonHSpace
        cardNameWithCopyGr.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(backgroundCardImage)
        layoutMargins = .zero
        backgroundCardImage.alignConstraintsToView(view: self)
        addSubview(cardNrGroup)
        addSubview(dateCvvGroup)
        addSubview(cardNameWithCopyGr)
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        // TODO: I think it could be better to provide interitem spacing then space to upper edge of each group
        leftAlignmentConstraint = cardNrGroup.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.InitialConstraints.leftAlignment)
        leftAlignmentConstraint?.isActive = true
        dateCvvGroup.leadingAnchor.constraint(equalTo: cardNrGroup.leadingAnchor).isActive = true
        cardNameWithCopyGr.leadingAnchor.constraint(equalTo: cardNrGroup.leadingAnchor).isActive = true
        
        cardNumberGroupTopConstraint = cardNrGroup.topAnchor.constraint(equalTo: topAnchor, constant: Constants.InitialConstraints.cardNumberGroupTop)
        cardNumberGroupTopConstraint?.isActive = true
        dateCvvGroupTopConstraint = dateCvvGroup.topAnchor.constraint(equalTo: topAnchor, constant: Constants.InitialConstraints.dateCvvGroupTop)
        dateCvvGroupTopConstraint?.isActive = true
        holderNameTopConstraint = cardNameWithCopyGr.topAnchor.constraint(equalTo: topAnchor, constant: Constants.InitialConstraints.holderNameTop)
        holderNameTopConstraint?.isActive = true
        
        hideUI(true)
    }
    // MARK: - Public
    /// Set the input for the NICardView
    /// - Parameters:
    ///   - input: input needed for the card details visualization
    ///   - service: sdk instance
    public func configure(
        language: NILanguage?,
        displayAttributes: NIDisplayAttributes = .zero,
        elementsColor: UIColor = .niAlwaysWhite,
        maskableValues: Set<UIElement.CardDetails.Value> = Set(UIElement.CardDetails.Value.allCases),
        service: CardDetailsService,
        completion: @escaping (NIErrorResponse?) -> Void
    ) {
        self.maskableValues = maskableValues
        
        // update colors of images
        [eyeButton, cardNrCopyButton, nameCopyButton].forEach { button in
            button.tintColor = elementsColor
            button.imageView?.tintColor = elementsColor
        }
        
        // if labels color was not provided - use same as elementsColor
        var missingColors = [UIElementColor]()
        UIElement.CardDetails.Label.allCases.forEach { label in
            if displayAttributes.cardAttributes.colors.color(for: label) == nil {
                missingColors.append(UIElementColor(element: label, color: elementsColor))
            }
        }
        UIElement.CardDetails.Value.allCases.forEach { label in
            if displayAttributes.cardAttributes.colors.color(for: label) == nil {
                missingColors.append(UIElementColor(element: label, color: elementsColor))
            }
        }
        displayAttributes.cardAttributes.colors = displayAttributes.cardAttributes.colors + missingColors
        
        presenter.setup(language: language, displayAttributes: displayAttributes, service: service)
        
        backgroundColor = UIColor.backgroundColor
        overrideUserInterfaceStyle = self.presenter.isThemeLight ? .light : .dark
        eyeButton.isSelected = presenter.maskedElements.isEmpty
        
        hideUI(true)
        activityIndicator.startAnimating()
        presenter.showCardDetails { [weak self] errorResponse in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.hideUI(false)
                completion(errorResponse)
            }
        }
    }
    
    public func setBackgroundImage(image: UIImage?) {
        backgroundCardImage.image = image
    }
    
    public func updatePositioning(_ textPositioning: NICardDetailsTextPositioning?) {
        guard let constraints = textPositioning else { return }
        if bounds == .zero {
            setNeedsLayout()
            layoutIfNeeded()
        }
        self.leftAlignmentConstraint?.constant = CGFloat(constraints.leftAlignment * bounds.width)
        self.cardNumberGroupTopConstraint?.constant = CGFloat(constraints.cardNumberGroupTopAlignment * bounds.height)
        self.dateCvvGroupTopConstraint?.constant = CGFloat(constraints.dateCvvGroupTopAlignment * bounds.height)
        self.holderNameTopConstraint?.constant = CGFloat(constraints.cardHolderNameGroupTopAlignment * bounds.height)
    }
}

// MARK: - Private
private extension NICardView {
    enum Constants {
        static let eyeImageSize = CGSize(width: 20, height: 20)
        static let copyButtonHSpace: CGFloat = 14
        static let dateCvvHSpace: CGFloat = 24
        enum InitialConstraints {
            static let leftAlignment: CGFloat = 16
            static let cardNumberGroupTop: CGFloat = 16
            static let dateCvvGroupTop: CGFloat = 57
            static let holderNameTop: CGFloat = 95
        }
    }
    
    func hideUI(_ shouldHide: Bool) {
        presenter.toggle(isHidden: shouldHide)
        eyeButton.isHidden = shouldHide
        cardNrCopyButton.isHidden = shouldHide || presenter.isMasked(.cardNumber)
        nameCopyButton.isHidden = shouldHide || presenter.isMasked(.cardHolder)
    }
    
    // MARK: - Actions
    @objc func cardNrCopyAction() {
        presenter.copyToClipboard([.cardNumber])
        showToast(message: NIResource.L10n.toastMessage.localized(with: presenter.language))
    }
    
    @objc func nameCopyAction() {
        presenter.copyToClipboard([.cardHolder])
        showToast(message: NIResource.L10n.toastMessage.localized(with: presenter.language))
    }
    
    @objc func eyeButtonAction(_ sender: EyeButton) {
        sender.isSelected.toggle()
        let maskedValues = sender.isSelected ? Set() : maskableValues
        presenter.toggle(isMasked: maskedValues)
        
        cardNrCopyButton.isHidden = !sender.isSelected
        nameCopyButton.isHidden = !sender.isSelected
    }
}

private extension UIView {
    func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "NotoSansOriya", size: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.sizeToFit()
        toastLabel.frame = CGRect(x: self.frame.midX - (toastLabel.frame.width + 40) / 2, y: self.frame.size.height - 80, width: toastLabel.frame.width + 40, height: toastLabel.frame.height + 24)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 20
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
