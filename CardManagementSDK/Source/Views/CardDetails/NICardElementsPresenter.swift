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

typealias FontAndColorAssignable = FontAssignable & ColorAssignable

public class NICardElementsPresenter {
    public private(set) lazy var cardNumber = Element(
        titleLabel: .cardNumber,
        valueLabel: .cardNumber,
        displayAttributes: displayAttributes,
        shareProvider: ({ [weak self] in
            self?.cardDetails.cardNumber
        })
    )
    public private(set) lazy var cardExpiry = Element(
        titleLabel: .expiry,
        valueLabel: .expiry,
        displayAttributes: displayAttributes,
        shareProvider: ({ [weak self] in
            self?.cardDetails.cardExpiry
        })
    )
    public private(set) lazy var cardCvv = Element(
        titleLabel: .cvv,
        valueLabel: .cvv,
        displayAttributes: displayAttributes,
        shareProvider: ({ [weak self] in
            self?.cardDetails.cvv2
        })
    )
    public private(set) lazy var cardHolder = Element(
        titleLabel: .cardHolder,
        valueLabel: .cardHolder,
        displayAttributes: displayAttributes,
        shareProvider: ({ [weak self] in
            self?.cardDetails.cardholderName
        })
    )
    
    public private(set) var maskedElements = Set(UIElement.CardDetails.Value.allCases)
    public var isThemeLight: Bool { displayAttributes.theme == .light }

    private var displayAttributes: NIDisplayAttributes = .zero
    private var service: CardDetailsService?
    private var cardDetails = CardDetails()
    
    public func setup(displayAttributes: NIDisplayAttributes, service: CardDetailsService) {
        self.displayAttributes = displayAttributes
        self.service = service
        maskedElements = displayAttributes.cardAttributes.shouldBeMaskedDefault
        GlobalConfig.shared.language = displayAttributes.language
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
    
    public func toggle(isMasked maskedElements: Set<UIElement.CardDetails.Value>) {
        self.maskedElements = maskedElements
        update()
    }
    
    public func isMasked(_ label: UIElement.CardDetails.Value) -> Bool {
        maskedElements.contains(label)
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

extension NICardElementsPresenter {
    public class Element {
        public let title: UILabel
        public let value: TextValueContainer
        
        private let shareProvider: () -> String?
        
        private let titleLabel: UIElement.CardDetails.Label
        private let valueLabel: UIElement.CardDetails.Value
        
        init(
            titleLabel: UIElement.CardDetails.Label,
            valueLabel: UIElement.CardDetails.Value,
            displayAttributes: NIDisplayAttributes,
            shareProvider: @escaping () -> String?
        ) {
            self.titleLabel = titleLabel
            self.valueLabel = valueLabel
            self.title = UIView.makeLabel(element: titleLabel, displayAttributes: displayAttributes, text: nil)
            self.value = UIView.makeWrappedLabel(element: valueLabel, displayAttributes: displayAttributes, text: nil)
            self.shareProvider = shareProvider
            
            GlobalConfig.shared.language = displayAttributes.language
        }
        func update(title: String?, value: String?, with displayAttributes: NIDisplayAttributes) {
            self.title.text = title
            self.title.font = displayAttributes.fonts.font(for: titleLabel)
            self.title.textColor = displayAttributes.cardAttributes.colors.color(for: titleLabel).fallback
            self.value.wrappedFont = displayAttributes.fonts.font(for: valueLabel)
            self.value.wrappedText = value
            self.value.wrappedColor = displayAttributes.cardAttributes.colors.color(for: valueLabel).fallback
        }
        
        public func copyToClipboard() {
            UIPasteboard.general.string = shareProvider()
        }
    }
}

private extension NICardElementsPresenter {
    struct CardDetails {
        var cardNumber: String?
        var maskedCardNumber: String?
        var cardholderName: String?
        var cardExpiry: String?
        var cvv2: String?
        
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
        // TODO: introduce cardDetailsLiveData, similar to Android
        var cardHolderData = cardDetails.cardholderName
        var cardNumberData = cardDetails.cardNumber
        var cardExpiryData = cardDetails.cardExpiry
        var cardCvvData = cardDetails.cvv2
        for maskedLabel in maskedElements {
            switch maskedLabel {
            case .cardHolder:
                cardHolderData = cardDetails.masked.cardholderName
            case .cardNumber:
                cardNumberData = cardDetails.masked.cardNumber
            case .expiry:
                cardExpiryData = cardDetails.masked.cardExpiry
            case .cvv:
                cardCvvData = cardDetails.masked.cvv2
            }
        }
        
        cardNumber.update(
            title: displayAttributes.cardAttributes.labels[.cardNumber, default: NIResource.L10n.cardNumberKey.localized],
            value: cardNumberData,
            with: displayAttributes
        )
        cardExpiry.update(
            title: displayAttributes.cardAttributes.labels[.expiry, default: NIResource.L10n.cardExpiryKey.localized],
            value: cardExpiryData,
            with: displayAttributes
        )
        cardCvv.update(
            title: displayAttributes.cardAttributes.labels[.cvv, default: NIResource.L10n.cardCvvKey.localized],
            value: cardCvvData,
            with: displayAttributes
        )
        cardHolder.update(
            title: displayAttributes.cardAttributes.labels[.cardHolder, default: NIResource.L10n.cardNameKey.localized],
            value: cardHolderData,
            with: displayAttributes
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
    static func makeLabel(element: any FontAndColorAssignable, displayAttributes: NIDisplayAttributes, text: String?) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = displayAttributes.fonts.font(for: element)
        label.text = text
        label.textColor = displayAttributes.cardAttributes.colors.color(for: element).fallback
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }
    
    static func makeWrappedLabel(element: UIElement.CardDetails.Value, displayAttributes: NIDisplayAttributes, text: String?) -> TextValueContainer {
        
        let label = WrappedValueView(element: element, displayAttributes: displayAttributes, text: text)
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
    
    init(element: UIElement.CardDetails.Value, displayAttributes: NIDisplayAttributes, text: String?) {
        label = UIView.makeLabel(element: element, displayAttributes: displayAttributes, text: text)
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

private extension Optional where Wrapped == UIColor {
    var fallback: UIColor {
        if #available(iOS 13.0, *) {
            return self ?? UIColor.label
        } else {
            return self ?? UIColor.niAlwaysWhite
        }
    }
}
