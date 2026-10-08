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
    public private(set) lazy var cardNumber = Element(
        shareProvider: ({ [weak self] in
            self?.cardDetails.cardNumber
        })
    )
    public private(set) lazy var cardExpiry = Element(
        shareProvider: ({ [weak self] in
            self?.cardDetails.cardExpiry
        })
    )
    public private(set) lazy var cardCvv = Element(
        shareProvider: ({ [weak self] in
            self?.cardDetails.cvv2
        })
    )
    public private(set) lazy var cardHolder = Element(
        shareProvider: ({ [weak self] in
            self?.cardDetails.cardholderName
        })
    )
    
    public private(set) var maskedElements = Set(UIElement.CardDetails.allCases)

    private var cardAttributes: NICardAttributes = .zero
    private var service: CardDetailsService?
    private var cardDetails = CardDetails()
    
    public func setup(cardAttributes: NICardAttributes, service: CardDetailsService) {
        self.cardAttributes = cardAttributes
        self.service = service
        maskedElements = cardAttributes.shouldBeMaskedDefault
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
                self.maskedElements = Set(UIElement.CardDetails.allCases)
                self.update()
                completion(error ?? NIErrorResponse(error: NISDKErrors.NO_DATA_ERROR))
            }
        }
    }
    
    // MARK: - Actions
    
    public func toggle(isMasked maskedElements: Set<UIElement.CardDetails>) {
        self.maskedElements = maskedElements
        update()
    }
    
    public func isMasked(_ label: UIElement.CardDetails) -> Bool {
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
    
    public func copyToClipboard(_ elements: [UIElement.CardDetails] = [.cardNumber], template: String? = "%@") {
        guard !elements.isEmpty else { return }
        let values = elements.compactMap {
            switch $0 {
            case .cardHolder: return self.cardHolder.shareProvider()
            case .cardNumber: return self.cardNumber.shareProvider()
            case .cvv: return self.cardCvv.shareProvider()
            case .expiry: return self.cardExpiry.shareProvider()
            }
        }
        if let template = template {
            UIPasteboard.general.string = String(format: template, arguments: values)
        } else {
            UIPasteboard.general.string = values.joined(separator: "/n")
        }
    }
}

extension NICardElementsPresenter {
    public class Element {
        public let title: UILabel
        public let value: TextValueContainer
        
        fileprivate let shareProvider: () -> String?
        
        init(
            shareProvider: @escaping () -> String?
        ) {
            self.title = UIView.makeLabel(attributedText: nil)
            self.value = UIView.makeWrappedLabel(attributedText: nil)
            self.shareProvider = shareProvider
        }
        
        internal func update(titleAttributedText: NSAttributedString?, valueAttributedText: NSAttributedString?) {
            self.title.attributedText = titleAttributedText
            self.value.wrappedAttributedText = valueAttributedText
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
            
            let maskedCvv = self.cvv2?.masked()
            
            return CardDetails(cardNumber: self.maskedCardNumber,
                               maskedCardNumber: self.maskedCardNumber,
                               cardholderName: maskedHolder,
                               cardExpiry: maskedExpiry,
                               cvv2: maskedCvv)
        }
    }
    
    func titleAttributedText(_ label: UIElement.CardDetails) -> NSAttributedString {
        cardAttributes.labels[label] ??
        label.defaultAttributedText(color: .label)
    }
    func valueAttributedText(_ label: UIElement.CardDetails, value: String?) -> NSAttributedString? {
        guard let value = value else { return nil }
        let attrs: [NSAttributedString.Key : Any] = cardAttributes.valueAttributes[label] ?? [.font : label.defaultValueFont, .foregroundColor: UIColor.label]
        return NSAttributedString(
            string: value,
            attributes: attrs
        )
    }
    
    func update() {
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
            titleAttributedText: titleAttributedText(.cardNumber),
            valueAttributedText: valueAttributedText(
                .cardNumber,
                value: cardNumberData?.separate(every: 4, with: " ")
            )
        )
        cardExpiry.update(
            titleAttributedText: titleAttributedText(.expiry),
            valueAttributedText: valueAttributedText(
                .expiry,
                value: cardExpiryData
            )
        )
        cardCvv.update(
            titleAttributedText: titleAttributedText(.cvv),
            valueAttributedText: valueAttributedText(
                .cvv,
                value: cardCvvData
            )
        )
        cardHolder.update(
            titleAttributedText: titleAttributedText(.cardHolder),
            valueAttributedText: valueAttributedText(
                .cardHolder,
                value: cardHolderData
            )
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
            cardNumber: cardNumber,
            maskedCardNumber: maskedCardNumber,
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
    static func makeLabel(attributedText: NSAttributedString?) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.attributedText = attributedText
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }
    
    static func makeWrappedLabel(attributedText: NSAttributedString?) -> TextValueContainer {
        
        let label = WrappedValueView(attributedText: attributedText)
        return label
    }
}

public protocol TextValueContainer: UIView {}
extension UILabel: TextValueContainer {}
internal extension TextValueContainer {
    private var label: UILabel? {
        self as? UILabel ?? self.subviews.first as? UILabel
    }
    var wrappedAttributedText: NSAttributedString? {
        get {
            label?.attributedText
        }
        set {
            label?.attributedText = newValue
        }
    }
}

private class WrappedValueView: UIView, TextValueContainer {
    // TODO: prefer drawing instead of holding label
    private let label: UILabel
    
    var wrappedAttributedText: NSAttributedString? {
        get { label.attributedText }
        set { label.attributedText = newValue }
    }
    
    init(attributedText: NSAttributedString?) {
        label = UIView.makeLabel(attributedText: attributedText)
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
