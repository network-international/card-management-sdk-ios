//
//  NICardView.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 24.11.2022.
//

import UIKit

public final class NICardView: UIView {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardExpiryLabel: UILabel!
    @IBOutlet weak var cardExpiry: UILabel!
    @IBOutlet weak var cvv2Label: UILabel!
    @IBOutlet weak var cvv2: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var eyeButton: EyeButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var backgroundCardImage: UIImageView!
    @IBOutlet weak var nameTagLabel: UILabel!
    @IBOutlet weak var nameCopyButton: UIButton!
    
   
    var viewModel: CardDetailsViewModel?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        view.layer.borderColor = UIColor.white.cgColor
        view.clipsToBounds = true
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 20
        eyeButton.isHidden = true
        hideUI(true)
    }
    
    // MARK: - Init
    /// Initialization of NICardView
    /// To be used when creating the card view programatically
    /// - Parameters:
    ///   - input: input needed for the card details visualization
    public init(input: NIInput) {
        viewModel = CardDetailsViewModel(input: input)
        super.init(frame: .zero)
        fromNib()
        
        if self.view != nil {
            activityIndicator.startAnimating()
            configureCardView()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
    }
    
    // MARK: - Public
    /// Set the input for the NICardView
    /// To be used ONLY if NICardView is added in storyboard or xib
    /// - Parameters:
    ///   - input: input needed for the card details visualization
    public func setInput(input: NIInput) {
        viewModel = CardDetailsViewModel(input: input)
        activityIndicator.startAnimating()
        configureCardView()
    }
    
}

// MARK: - Private
extension NICardView {
    
    func configureCardView() {
        
        guard let viewModel = viewModel else {
            return
        }
        
        /// set background image
        if let image = viewModel.backgroundImage {
            backgroundCardImage.image = image
        }
        
        /// set fonts
        cardNumberLabel.font = viewModel.font(for: .cardNumberLabel)
        cardExpiryLabel.font = viewModel.font(for: .expiryDateLabel)
        cvv2Label.font = viewModel.font(for: .cvvLabel)
        cardNumber.font = viewModel.font(for: .cardNumberValueLabel)
        nameLabel.font = viewModel.font(for: .cardholderNameLabel)
        cardExpiry.font = viewModel.font(for: .expiryDateValueLabel)
        cvv2.font = viewModel.font(for: .cvvValueLabel)
        nameTagLabel.font = viewModel.font(for: .cardholderNameTagLabel)
        
        updateUI(viewModel)
        updateTexts(viewModel)
    }
    
    private func updateUI(_ viewModel: CardDetailsViewModel) {
        viewModel.bindCardDetailsViewModel = {
            DispatchQueue.main.async {
                self.updateTexts(viewModel)
                self.activityIndicator.stopAnimating()
                self.hideUI(false)
                self.eyeButton.isHidden = !viewModel.shouldMask
            }
        }
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.backgroundColor
            overrideUserInterfaceStyle = viewModel.input.displayAttributes?.theme == .light ? .light : .dark
            copyButton.setImage(UIImage(systemName: "rectangle.portrait.on.rectangle.portrait"), for: .normal)
        } else {
            view.backgroundColor = viewModel.input.displayAttributes?.theme == .light ? .white : UIColor.darkerGrayLight
            let image = UIImage(named: "icon_copy", in: Bundle.sdkBundle, compatibleWith: .none)
            copyButton.setImage(image, for: .normal)
        }
    }
    
    private func updateTexts(_ viewModel: CardDetailsViewModel) {
        eyeButton.isSelected = !viewModel.shouldMask
        
        let cardDetails = viewModel.shouldMask ? viewModel.maskedDetails : viewModel.cardDetails
        self.cardNumberLabel.text = cardDetails?.cardNumberLabel
        self.cardNumber.text = cardDetails?.cardNumber
        self.nameLabel.text = cardDetails?.cardholderName
        self.cardExpiryLabel.text = cardDetails?.cardExpiryLabel
        self.cardExpiry.text = cardDetails?.cardExpiry
        self.cvv2Label.text = cardDetails?.cvv2Label
        self.cvv2.text = cardDetails?.cvv2
        self.nameTagLabel.text = cardDetails?.cardholderNameLabel
    }
    
    private func hideUI(_ shouldHide: Bool) {
        cardNumberLabel.isHidden = shouldHide
        cardNumber.isHidden = shouldHide
        nameLabel.isHidden = shouldHide
        cardExpiryLabel.isHidden = shouldHide
        cardExpiry.isHidden = shouldHide
        cvv2Label.isHidden = shouldHide
        cvv2.isHidden = shouldHide
        nameTagLabel.isHidden = shouldHide
        
        copyButton.isHidden = shouldHide
        nameCopyButton.isHidden = shouldHide
    }
    
    // MARK: - Actions
    @IBAction func copyAction(_ sender: Any) {
        UIPasteboard.general.string = viewModel?.cardDetails?.cardNumber?.removingWhitespaces()
        showToast(message: "toast_message".localized)
    }
    
    @IBAction func nameCopyAction(_ sender: Any) {
        UIPasteboard.general.string = viewModel?.cardDetails?.cardholderName
        showToast(message: "toast_message".localized)
    }
    
    @IBAction func eyeButtonAction(_ sender: EyeButton) {
        sender.isSelected.toggle()
        
        guard let card = viewModel?.cardDetails else { return }
        if sender.isSelected {
            self.nameLabel.text = card.cardholderName
            self.cardNumber.text = card.cardNumber
            self.cardExpiry.text = card.cardExpiry
            self.cvv2.text = card.cvv2
        } else {
            self.cardNumber.text = card.maskedCardNumber
            self.nameLabel.text = viewModel?.maskedDetails.cardholderName
            self.cardExpiry.text = viewModel?.maskedDetails.cardExpiry
            self.cvv2.text = viewModel?.maskedDetails.cvv2
        }
    }
    
    private func showToast(message : String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "NotoSansOriya", size: 16)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.sizeToFit()
        toastLabel.frame = CGRect(x: self.view.frame.midX - (toastLabel.frame.width + 40) / 2, y: self.view.frame.size.height - 80, width: toastLabel.frame.width + 40, height: toastLabel.frame.height + 24)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 20
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}


extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            /// xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutSetup()
        return contentView
    }
    
    private func layoutSetup() {
        superview?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        superview?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        superview?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        superview?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}
