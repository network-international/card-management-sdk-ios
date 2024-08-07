# Network International iOS Card Management SDK

The Network International iOS Card Management SDK allows you to integrate with Network International standard APIs for card management. (https://developer.network.ae)
The current supported features are:
1. Get Secured Card Details : Display a card component providing the ability to show card number, expiry date, CVV and cardholder name. This supports full end to end encryption to securely transport this sensitive information.
2. Set PIN : Displays a PIN pad to allow cardholder to set a PIN on their new card. The PIN is end to end encrypted to securely transport this sensitive information
3. Change PIN: Displays two PIN pad to allow the cardholder to change their PIN by providing old & new PIN. The PINs are end to end encrypted to securely transport this sensitive information
4. Verify PIN: Displays a PIN pad to allow cardholder to verify PIN on their card. The PIN is end to end encrypted to securely transport this sensitive information
5. View PIN: Displays a component providing the ability to show PIN card. The PIN is end to end encrypted to securely transport this sensitive information

## Requirements
The Network International iOS Card Management SDK requires Xcode 13 and later and works with iOS version 15 and above.

## Installation
The SDK can be added via [CocoaPods](https://cocoapods.org/)

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
TokenFetcherFactory.makeSimpleWrapper(tokenValue: "your generated token")
```
3) Use simple sdk's provider that will try to fetch token with POST request and cache it in device's keychain
```
TokenFetcherFactory.makeNetworkWithCache(
    urlString: "your url", 
    credentials: ClientCredentials // clientId, clientSecret
)
```

###### Create SDK instance
Swift:
```swift
    let sdk = NICardManagementAPI(
            rootUrl: rootUrl,
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            bankCode: bankCode,
            tokenFetchable: NICardManagementTokenFetchable
        )
```

###### Display attributes  
Display attributes parameter has default value `NIDisplayAttributes.zero`. You can set one or more attributes, or even none of them.  

1. Theme

We support dark and light mode, by setting the theme parameter from the display attributes. If the Customer App is in dark mode, then you should use our SDK with dark theme. If the Customer App is in light mode, then you should use our SDK with light theme.  

2. Language

Languages supported are English and Arabic. You can either set the desired language or not. 
If you don’t set any language, it will use the device language, if supported, otherwise will default to English. 

3. Fonts

We support customization of fonts. System and custom fonts can be set for the labels of each form view.  

4. Card Attributes

Card Attributes has default value `NICardAttributes.zero`. It can be set if customisation of the card details view is wanted. 
    
We offer:  
 - Set colors of card view elements, `.niAlwaysWhite` by default for cardView and `.label` for custom layout
 
```swift
    let cardAttributes = NICardAttributes(colors: [UIElementColor(element: UIElement.CardDetails.Value.cardNumber, color: .purple)])
```

 - Define which elements will be masked by default
 
 To directly show the card details (not masked) when card view is displayed, we expect the ```shouldBeMaskedDefault``` property to be set to emtpy set. Or concrete elements can be masked by default 
 
```swift
    let cardAttributes = NICardAttributes(shouldBeMaskedDefault: Set([.cvv]))
```

- Define labels for cardView elements
 
 To define custom texts for cardView labels - use `labels` 
 
```swift
    let cardAttributes = NICardAttributes(labels: [
                .cardNumber: "My card >>", // use localised strings here
                .cvv: "My CVV >>"
            ])
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
// toggle cardPresenter.isMasked (the way how information displayed) 
// - by `displayAttributes.cardAttributes.shouldHide`
let cardPresenter = sdk.buildCardDetailsPresenter(displayAttributes: displayAttributes, language: nil)
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
cardPresenter.toggle(isMasked: Set(UIElement.CardDetails.Value.allCases))
```

##### Constructing Card Details view.
A view of NICardView type can be added into storyboard or created programmatically
```swift
let cardView = NICardView()
```
then start the flow as below:
```swift
cardView.configure(
    language: nil,
    displayAttributes: displayAttributes, // type NIDisplayAttributes - see the explanation above
    maskableValues: Set(UIElement.CardDetails.Value.allCases), // set of elements that will be toggled by "show" button
    service: sdk // CardDetailsService protocol, use sdk instance
    ) { errorResponse in
// check if errorResponse is not nil and handle error
}
// customize background image and text position
cardView.setBackgroundImage(image: backgroundImage)
cardView.updatePositioning(textPositioning)
```

##### Display View Pin View

A view of NIViewPinView type can be added into storyboard, then set the input and start the flow as below:
```swift
viewPinView.configure(displayAttributes: displayAttributes, service: sdk, timer: 5, color: .black) { successResponse, errorResponse in
// handle here error and success
}
```
or the NIViewPinView can be created programmatically and initialized as below:
```swift
let viewPinView = NIViewPinView(displayAttributes: displayAttributes, service: sdk, timer: 5, color: .red) { successResponse, errorResponse in
// handle here error and success
}
```
Parameters: 
- displayAttributes - type NIDisplayAttributes - see the explanation above. - service - CardDetailsService protocol, use sdk instance
- timer - type Double - offers possibility to set the display time of the PIN, expressed in seconds. Using value "0" for this parameter, the PIN will be displayed indefinitely. After the countdown, the PIN will be masked.
This is a required parameter.
- color - type UIColor - offers possibility to set the color of the elements contained in the view. This is an optional parameter.

#### Form Factory Interface
##### Display Card Details in a new screen (UIViewController).
The card info displayed are: Card Number, Expiry Date, CVV and Cardholder Name.

```swift
    sdk.displayCardDetailsForm(
        viewController: navigationViewController, 
        cardViewBackground: UIImage(resource: .background), 
        cardViewTextPositioning: nil
        ) { successResponse, errorResponse in
        // handle error and success
    }
```

##### Set PIN Form 
A PIN-pad will be displayed into a separate screen (UIViewController). 

specify required pin type (pin length 4...6): `let pinType = NIPinFormType.dynamic`

```swift
sdk.setPinForm(type: pinType, viewController: navigationViewController, displayAttributes: displayAttributes) { successResponse, errorResponse in
	//  handle here error and success
}
```

##### Change PIN Form 
A PIN-pad will be displayed into a separate screen (UIViewController).
Change PIN is a two step flow:
1.Capture current PIN 
2.Capture new PIN 

specify required pin type (pin length 4...6): `let pinType = NIPinFormType.dynamic`

```swift
sdk.changePinForm(type: pinType, viewController: navigationViewController, displayAttributes: displayAttributes) { successResponse, errorResponse in
	// handle here error and success
}
```

##### Verify PIN Form 
A PIN-pad will be displayed into a separate screen (UIViewController). 

specify required pin type (pin length 4...6): `let pinType = NIPinFormType.dynamic`

```swift
sdk.verifyPinForm(type: pinType, viewController: navigationViewController, displayAttributes: displayAttributes) { successResponse, errorResponse in
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


##### View PIN
The programmatic interface for the View PIN functionality will return a String value representing the PIN or failure response.

Swift:
```swift
sdk.getPin { pin, errorResponse in
    //  handle here error and success
}
```

# Sample application
Check sample application in "Example" directory with SDK usage