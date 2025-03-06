# Network International iOS Card Management SDK

The Network International iOS Card Management SDK allows you to integrate with Network International standard APIs for card management. (https://developer.network.ae)
The current supported features are:
1. Get Secured Card Details : Display a card component providing the ability to show card number, expiry date, CVV and cardholder name. This supports full end to end encryption to securely transport this sensitive information.
2. Set PIN : Displays a PIN pad to allow cardholder to set a PIN on their new card. The PIN is end to end encrypted to securely transport this sensitive information
3. Change PIN: Displays two PIN pad to allow the cardholder to change their PIN by providing old & new PIN. The PINs are end to end encrypted to securely transport this sensitive information
4. Verify PIN: Displays a PIN pad to allow cardholder to verify PIN on their card. The PIN is end to end encrypted to securely transport this sensitive information

## Requirements
The Network International iOS Card Management SDK requires Xcode 13 and later and works with iOS version 15 and above.

## Installation
Choose desired option:
- The SDK can be added via [CocoaPods](https://cocoapods.org/)
- Download framework file from github releases section and add it to your project manually

##### CocoaPods
The steps to install it via CocoaPods:
1.	Create a Podfile in the root directory where the .xcodeproj file resides.
2.	Add pod 'NICardManagementSDK’ to the Podfile created in the above step.
3.	Close Xcode and run pod install command on the directory where the Podfile was created.
4.	After performing the above step, open the .xcworkspace file that was created, to open your project.


## Integration

#### Basics
After you have installed the SDK, by following one of the above set of steps, you can import the SDK into your iOS app and used it.

Swift:
```swift
import NICardManagementSDK
```


#### Usage

###### Decide how `token` will be provided - create `tokenFetchable`(`NICardManagementTokenFetchable`), available options:
1) Implement you own provider that meet protocol requiremets
2) If you have token - you can use simple wrapper
```
let tokenFetcher = TokenFetcherFactory.makeSimpleWrapper(tokenValue: "your generated token")
```

###### Create SDK instance
Swift:
```swift
    let sdk = NICardManagementAPI(
            rootUrl: connection.baseUrl,
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            bankCode: bankCode,
            tokenFetchable: tokenFetcher,
            // pass nil if there are no needs in extra headers
            extraHeadersProvider: NICardManagementExtraHeaders,
            // pass nil or add logger for debugging, like NICardManagementLogging()
            logger: NICardManagementLogger
        )
```

- Use `NICardManagementExtraHeaders` when need to add some specific httpHeaders for each SDK http request, for example to bypass additional firewalls
```swift
final class AdditionalDemoHeadersProvider: NICardManagementExtraHeaders {
    func additionalNetworkHeaders() -> [String: String] {
        ["extraHeader1": "DemoExtraHttpHeaderValue"]
    }
}
```

###### Configure appearance

1. Card Attributes

Card Attributes has default values `NICardAttributes.zero` or `NICardAttributes.niAlwaysWhite`.
- `NICardAttributes.zero` - default fonts and `UIColor.label` will be used for card elements.
- `NICardAttributes.niAlwaysWhite` - default fonts and `UIColor.niAlwaysWhite` will be used for card elements, this color ignores Theme setting (light/dark).
- use custom configuration to provide necessary string attributes (font, color, ...) for any card details elemend
```swift
    NICardAttributes(
        // configure elements that will be masked
        shouldBeMaskedDefault: Set<UIElement.CardDetails> = Set(UIElement.CardDetails.allCases),
        // [UIElement.CardDetails: NSAttributedString]
        // provide desired attributed string for card details label
        labels: UIElement.CardDetails.allCases.reduce(into: [:], { partialResult, label in
            partialResult[label] = label.defaultAttributedText(color: .niAlwaysWhite)
        }),
        // [UIElement.CardDetails: [NSAttributedString.Key: Any]]
        // provide desired String attributes that will be applied to card details value holder
        valueAttributes: UIElement.CardDetails.allCases.reduce(into: [:], { partialResult, label in
            partialResult[label] = [.font: label.defaultValueFont, .foregroundColor: UIColor.niAlwaysWhite]
        })
```
 - Define which elements will be masked by default
 
 To directly show the card details (not masked) when card view is displayed, we expect the ```shouldBeMaskedDefault``` property to be set to emtpy set. Or concrete elements can be masked by default 
 
```swift
    let cardAttributes = NICardAttributes(shouldBeMaskedDefault: Set([.cvv]))
```

- Define labels for cardView elements
 
 To define custom texts for cardView labels - use `labels` 
 
```swift
    let cardAttributes =         NICardAttributes(
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
            ]
    )
```

 - Background image customization

For the card background image, we expect a UIImage to be set. The recommended size would be 343 x 182. 

```swift
    let cardView = NICardView()
    cardView.setBackgroundImage(image: UIImage(named:"background_image"))
    cardView.updatePositioning(self.viewModel.textPositioning)
```
 - Possibility to set the text position as grouped labels
 
The card details labels are grouped as follows:
 - Card Number Group
    
 - Expiry Date & CVV Group
    
 - Card Holder Name Group
     
In order to set the position of the each group, we expect percentage (of card container view height and width) values to the following parameters: ```leftAlignment```, ```cardNumberGroupTopAlignment```, ```dateCvvGroupTopAlignment```, ```cardHolderNameGroupTopAlignment```

```swift
    let cardView = NICardView()
    cardView.updatePositioning(
         NICardDetailsTextPositioning(leftAlignment: 0.09, cardNumberGroupTopAlignment: 0.4, dateCvvGroupTopAlignment: 0.6, cardHolderNameGroupTopAlignment: 0.8)
    )
```

Most of the parameters are optional. 

    
#### Display Card Details as a view
The customer application can integrate Card Details and View Pin as a view into a UIViewController

##### Constructing Custom layout Card Details view from given UI elements.
SDK allows to build any layout for card details by getting UI elements with card details data, this will help to keep card details data protected and not pass it in a war data
```swift
let cardPresenter = sdk.buildCardDetailsPresenter(cardAttributes: NICardAttributes.zero)
// fetch data
cardPresenter.showCardDetails { errorResponse in
// check if errorResponse is not nil and handle error
}
// Composition of your layout by UI elements
let customView = UIStackView()
customView.axis = .vertical
customView.addArrangedSubview(cardPresenter.cardNumber.title)
customView.addArrangedSubview(cardPresenter.cardNumber.value)
customView.addArrangedSubview(cardPresenter.cardCvv.title)
customView.addArrangedSubview(cardPresenter.cardCvv.value)
customView.addArrangedSubview(cardPresenter.cardExpiry.title)
customView.addArrangedSubview(cardPresenter.cardExpiry.value)
customView.addArrangedSubview(cardPresenter.cardHolder.title)
customView.addArrangedSubview(cardPresenter.cardHolder.value)
```

Presenter allows copy values to clipbloard with given template
```swift
@objc func cardCopyAction() {
        let template = """
        cardNumber: %@
        cvv: %@
        expiry: %@
        """
        cardPresenter.copyToClipboard([.cardNumber, .cvv, .expiry], template: template)
        showToast(message: "Copied")
    }
```
Presenter can mask/unmask given set of elements, if set is empty - presenter will unmask all fields
```swift
cardPresenter.toggle(isMasked: Set(UIElement.CardDetails.allCases))
```

##### Constructing Card Details view.
A view of NICardView type can be added into storyboard or created programmatically
```swift
let cardView = NICardView()
```
then start the flow as below:
```swift
cardView.configure(
        cardAttributes: NICardAttributes.niAlwaysWhite,
        buttonsColor: .niAlwaysWhite, // define color for buttons
        maskableValues: Set(UIElement.CardDetails.allCases),
        service: sdk // CardDetailsService protocol, use sdk instance
    ) { errorResponse in
// check if errorResponse is not nil and handle error
}
// customize background image and text position
cardView.setBackgroundImage(image: backgroundImage)
cardView.updatePositioning(textPositioning)
```

#### Form Factory Interface
##### Display Card Details in a new screen (UIViewController).
The card info displayed are: Card Number, Expiry Date, CVV and Cardholder Name.

```swift
    sdk.displayCardDetailsForm(
        viewController: navigationViewController,
        cardAttributes: NICardAttributes.niAlwaysWhite,
        cardViewBackground: UIImage(resource: .background),
        cardViewTextPositioning: nil) { successResponse, errorResponse in
        // handle error and success
    }
```

#### Pin Form Factory Interface
A PIN-pad will be displayed into a separate screen (UIViewController). 

- provide desired text/color configuration if needed
```swift
    let pinVerifyConfig = VerifyPinViewModel.Config(
        descriptionAttributedText: NSAttributedString(
            string: NISDKStrings.verify_pin_description.rawValue,
            attributes: [.font : UIElement.PinFormLabel.verifyPinDescription.defaultFont, .foregroundColor: UIColor.label]
        ),
        titleText: NISDKStrings.verify_pin_title.rawValue,
        backgroundColor: .clear
    )
    let pinChangeConfig = ChangePinViewModel.Config(
        enterCurrentPinText: NSAttributedString(
            string: NISDKStrings.change_pin_description_enter_current_pin.rawValue,
            attributes: [.font : UIFont(name: "Helvetica", size: 18) ?? UIFont.systemFont(ofSize: 18), .foregroundColor: UIColor.label]
        ),
        enterNewPinText: ChangePinViewModel.Config.default.enterNewPinText,
        reEnterNewPinText: ChangePinViewModel.Config.default.reEnterNewPinText,
        notMatchPinText: ChangePinViewModel.Config.default.notMatchPinText,
        titleText: ChangePinViewModel.Config.default.titleText,
        backgroundColor: ChangePinViewModel.Config.default.backgroundColor
    )
    let pinSetConfig = SetPinViewModel.Config.default
```
- specify required pin type (pin length 4...6): `let pinType = NIPinFormType.dynamic`

##### Set PIN Form 

```swift
    sdk.setPinForm(type: pinType, config: pinSetConfig) { successResponse, errorResponse in
	//  handle here error and success
}
```

##### Change PIN Form 
Change PIN is a two step flow:
1.Capture current PIN 
2.Capture new PIN 

```swift
sdk.changePinForm(type: pinType, config: pinChangeConfig) { successResponse, errorResponse in
	// handle here error and success
}
```

##### Verify PIN Form 

```swift
sdk.verifyPinForm(type: pinType, config: pinVerifyConfig) { successResponse, errorResponse in
	// handle here error and success
}
```

#### Programatic Interface
The customer application will be responsible to handle the UI part.

##### Retrieve Card Details
The programmatic interface of the card details will return the card details in an object (NICardDetailsResponse).
The card info returned are: Card Number, Expiry Date, CVV and Cardholder Name.

Swift:
```swift
sdk.getCardDetails { successResponse, errorResponse in
    //  handle here error and success
}
```


##### Set PIN 
The programmatic interface for the Set PIN functionality will return a success or failure response.

Swift:
```swift
sdk.setPin(pin: pin) { successResponse, errorResponse in
    //  handle here error and success
}
```


##### Change PIN
The programmatic interface for the Change PIN functionality will return a success or failure response.

Swift:
```swift
sdk.changePin(oldPin: oldPin, newPin: newPin) { successResponse, errorResponse in
    //  handle here error and success
}
```


##### Verify PIN
The programmatic interface for the Verify PIN functionality will return a success or failure response.

Swift:
```swift
sdk.verifyPin(pin: pin) { successResponse, errorResponse in
    //  handle here error and success
}
```


# Sample application
Check sample application in "Example" directory with SDK usage
