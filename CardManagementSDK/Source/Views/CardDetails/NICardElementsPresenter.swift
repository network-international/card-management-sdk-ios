//
//  CardDetailsViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 07.10.2022.
//

import Foundation
import UIKit

public protocol CardDetailsService {
    func getCardDetails(completion: @escaping (NICardDetailsResponse?, NIErrorResponse?, @escaping () -> Void) -> Void)
}

public class NICardElementsPresenter {
    public class Element {
        public let title: UILabel
        public let value: TextValueContainer
        
        private let shareProvider: () -> String?
        
        init(title: UILabel, value: TextValueContainer, shareProvider: @escaping () -> String?) {
            self.title = title
            self.value = value
            self.shareProvider = shareProvider
        }
        func update(title: (font: UIFont, text: String?), value: (font: UIFont, text: String?), color: UIColor) {
            self.title.text = title.text
            self.title.font = title.font
            self.title.textColor = color
            self.value.wrappedFont = value.font
            self.value.wrappedText = value.text
            self.value.wrappedColor = color
        }
        
        public func copyToClipboard() {
            UIPasteboard.general.string = shareProvider()
        }
    }
    
    public private(set) lazy var cardNumber = Element(
        title: UIView.makeLabel(
            font: DefaultFonts.cardNumberLabel.font,
            text: nil, 
            color: displayAttributes.cardAttributes.elementsColor
        ),
        value: UIView.makeWrappedLabel(
            font: DefaultFonts.cardNumberValueLabel.font,
            text: nil,
            color: displayAttributes.cardAttributes.elementsColor
        ), 
        shareProvider: ({ [weak self] in
            self?.cardDetails.cardNumber
        })
    )
    public private(set) lazy var cardExpiry = Element(
        title: UIView.makeLabel(
            font: DefaultFonts.cardExpiryLabel.font,
            text: nil,
            color: displayAttributes.cardAttributes.elementsColor
        ),
        value: UIView.makeWrappedLabel(
            font: DefaultFonts.cardExpiryValueLabel.font,
            text: nil,
            color: displayAttributes.cardAttributes.elementsColor
        ),
        shareProvider: ({ [weak self] in
            self?.cardDetails.cardExpiry
        })
    )
    public private(set) lazy var cardCvv = Element(
        title: UIView.makeLabel(
            font: DefaultFonts.cardCvvLabel.font,
            text: nil,
            color: displayAttributes.cardAttributes.elementsColor
        ),
        value: UIView.makeWrappedLabel(
            font: DefaultFonts.cardCvvValueLabel.font,
            text: nil,
            color: displayAttributes.cardAttributes.elementsColor
        ),
        shareProvider: ({ [weak self] in
            self?.cardDetails.cvv2
        })
    )
    public private(set) lazy var cardHolder = Element(
        title: UIView.makeLabel(
            font: DefaultFonts.cardNameTagLabel.font,
            text: nil,
            color: displayAttributes.cardAttributes.elementsColor
        ),
        value: UIView.makeWrappedLabel(
            font: DefaultFonts.cardNameLabel.font,
            text: nil,
            color: displayAttributes.cardAttributes.elementsColor
        ),
        shareProvider: ({ [weak self] in
            self?.cardDetails.cardholderName
        })
    )
    
    public var isMasked: Bool { displayAttributes.cardAttributes.shouldHide }
    public var isThemeLight: Bool { displayAttributes.theme == .light }

    private var displayAttributes: NIDisplayAttributes = .default
    private var service: CardDetailsService?
    private var cardDetails = CardDetails()
    
    public func setup(displayAttributes: NIDisplayAttributes, service: CardDetailsService) {
        self.displayAttributes = displayAttributes
        self.service = service
        cardDetails.setNoData()
        update()
    }
    
    public func showCardDetails(completion: @escaping (NIErrorResponse?) -> Void) {
        guard let service = service else {
            completion(nil)
            return
        }
        // capture self explicitly
        service.getCardDetails { [self] success, error, callback in
            if let cardDetails = success?.toCardDetails {
                self.cardDetails = cardDetails
                self.update()
                completion(nil)
            } else {
                self.cardDetails.setNoData()
                self.update()
                completion(error ?? NIErrorResponse(error: NISDKErrors.NO_DATA_ERROR))
            }
        }
    }
    
    // MARK: - Actions
    
    public func toggle(isMasked: Bool) {
        let data = isMasked ? cardDetails.masked : cardDetails
        cardHolder.value.wrappedText = data.cardholderName
        cardNumber.value.wrappedText = data.cardNumber
        cardExpiry.value.wrappedText = data.cardExpiry
        cardCvv.value.wrappedText = data.cvv2
    }
    
    public func toggle(isHidden: Bool) {
        cardNumber.title.isHidden = isHidden
        cardNumber.value.isHidden = isHidden
        
        cardHolder.title.isHidden = isHidden
        cardHolder.value.isHidden = isHidden
        
        cardExpiry.title.isHidden = isHidden
        cardExpiry.value.isHidden = isHidden

        cardCvv.title.isHidden = isHidden
        cardCvv.value.isHidden = isHidden
    }
}

private extension NICardElementsPresenter {
    struct CardDetails {
        var cardNumberLabel: String = "card_number".localized
        var cardNumber: String?
        var maskedCardNumber: String?
        var cardholderName: String?
        var cardExpiryLabel: String = "card_expiry".localized
        var cardExpiry: String?
        var cvv2Label: String = "card_cvv".localized
        var cvv2: String?
        var cardholderNameLabel: String = "card_name".localized
        
        fileprivate mutating func setNoData() {
            cardNumber = "-"
            cardholderName = "-"
            cardExpiry = "-"
            cvv2 = "-"
            maskedCardNumber = "-"
        }
        
        fileprivate var masked: CardDetails {
            var maskedHolder = ""
            if let holderNames = self.cardholderName?.components(separatedBy: " ") {
                for name in holderNames {
                    maskedHolder.append("\(name.masked(offset: 2))")
                }
            }
            
            var maskedExpiry = ""
            if let dateComponents = self.cardExpiry?.components(separatedBy: "/") {
                for dateComponent in dateComponents {
                    maskedExpiry.append("\(dateComponent.masked(offset: 0))")
                    if dateComponent == dateComponents.first {
                        maskedExpiry.append("/")
                    }
                }
            }
            
            return CardDetails(cardNumber: self.maskedCardNumber,
                               maskedCardNumber: self.maskedCardNumber,
                               cardholderName: maskedHolder,
                               cardExpiry: maskedExpiry,
                               cvv2: self.cvv2?.masked())
        }
    }
    
    private func update() {
        let data = isMasked ? cardDetails.masked : cardDetails
        cardNumber.update(
            title: (font: displayAttributes.font(for: .cardNumberLabel),
                    text: data.cardNumberLabel),
            value: (font: displayAttributes.font(for: .cardNumberValueLabel),
                    text: data.cardNumber), 
            color: displayAttributes.cardAttributes.elementsColor
        )
        cardExpiry.update(
            title: (font: displayAttributes.font(for: .expiryDateLabel),
                    text: data.cardExpiryLabel),
            value: (font: displayAttributes.font(for: .expiryDateValueLabel),
                    text: data.cardExpiry),
            color: displayAttributes.cardAttributes.elementsColor
        )
        cardCvv.update(
            title: (font: displayAttributes.font(for: .cvvLabel),
                    text: data.cvv2Label),
            value: (font: displayAttributes.font(for: .cvvValueLabel),
                    text: data.cvv2),
            color: displayAttributes.cardAttributes.elementsColor
        )
        cardHolder.update(
            title: (font: displayAttributes.font(for: .cardholderNameTagLabel),
                    text: data.cardholderNameLabel),
            value: (font: displayAttributes.font(for: .cardholderNameLabel),
                    text: data.cardholderName),
            color: displayAttributes.cardAttributes.elementsColor
        )
    }
}

private extension NICardDetailsResponse {
    var toCardDetails: NICardElementsPresenter.CardDetails? {
        let response = self
        guard let cardNumber = response.clearPan, let maskedCardNumber = response.maskedPan, let expiry = response.expiry, let cvv2 = response.clearCVV2, let cardholderName = response.cardholderName else {
            return nil
        }
        return NICardElementsPresenter.CardDetails(
            cardNumber: cardNumber.separate(every: 4, with: " "),
            maskedCardNumber: maskedCardNumber.separate(every: 4, with: " "),
            cardholderName: cardholderName,
            cardExpiry: expiry,
            cvv2: cvv2
        )
    }
}

private extension String {
    func masked(_ character: String = "*", offset: Int = 0) -> String {
        guard !self.isEmpty, self.count > offset else { return self }
        let start = self.startIndex ..< self.index(self.startIndex, offsetBy: offset)
        let end = self.index(self.endIndex, offsetBy: 0) ..< self.endIndex
        let result = self[start] + Array(repeating: "*", count: self.count - offset) + self[end]
        return String(result)
    }
    
    func separate(every stride: Int, with separator: Character) -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}

private extension UIView {
    static func makeLabel(font: UIFont, text: String?, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = font
        label.text = text
        label.textColor = color
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }
    
    static func makeWrappedLabel(font: UIFont, text: String?, color: UIColor) -> TextValueContainer {
        
        let label = WrappedValueView(font: font, text: text, color: color)
        return label
    }
}

public protocol TextValueContainer: UIView {}
extension UILabel: TextValueContainer {}
internal extension TextValueContainer {
    private var label: UILabel? {
        self as? UILabel ?? self.subviews.first as? UILabel
    }
    var wrappedText: String? {
        get {
            label?.text
        }
        set {
            label?.text = newValue
        }
    }
    
    var wrappedFont: UIFont {
        get {
            label?.font ?? UIFont()
        } set {
            label?.font = newValue
        }
    }
    
    var wrappedColor: UIColor {
        get {
            label?.textColor ?? .niAlwaysWhite
        } set {
            label?.textColor = newValue
        }
    }
}

private class WrappedValueView: UIView, TextValueContainer {
    // TODO: prefer drawing instead of holding label
    private let label: UILabel
    
    var wrappedText: String? {
        get { label.text }
        set { label.text = newValue }
    }
    var wrappedFont: UIFont{
        get { label.font }
        set { label.font = newValue }
    }
    
    var wrappedColor: UIColor{
        get { label.textColor }
        set { label.textColor = newValue }
    }
    
    init(font: UIFont, text: String?, color: UIColor) {
        label = UIView.makeLabel(font: font, text: text, color: color)
        super.init(frame: .zero)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
