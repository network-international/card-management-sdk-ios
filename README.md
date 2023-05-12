# Network International iOS Card Management SDK

The Network International iOS Card Management SDK allows you to integrate with Network International standard APIs for card management. (https://developer.network.ae)
The current supported features are:
1. Get Secured Card Details : Display a card component providing the ability to show card number, expiry date, CVV and cardholder name. This supports full end to end encryption to securely transport this sensitive information.
2. Set PIN : Displays a PIN pad to allow cardholder to set a PIN on their new card. The PIN is end to end encrypted to securely transport this sensitive information
3. Change PIN: Displays two PIN pad to allow the cardholder to change their PIN by providing old & new PIN. The PINs are end to end encrypted to securely transport this sensitive information
4. Verify PIN: Displays a PIN pad to allow cardholder to verify PIN on their card. The PIN is end to end encrypted to securely transport this sensitive information

## Requirements
The Network International iOS Card Management SDK requires Xcode 13 and later and works with iOS version 12 and above.

## Installation
We support all the popular iOS dependency management tools. The SDK can be added via [CocoaPods](https://cocoapods.org/) or using [Swift Package Manager](https://swift.org/package-manager/). 
We offer, the possibility to add the XCFramework manually into your project, as well.

##### XCFramework
Steps to connect our iOS SDK to your iOS application:

1.	Drag NICardManagementSDK.xcframework to the Frameworks, Libraries and Embedded Content section of your project target: General -> Frameworks, Libraries and Embedded Content.
2.	Make sure the “Embed & Sign” option is set on Embed tab.
3.	If your application is written with Objective C, perform an additional step: Build settings -> Build Options -> Always Embed Swift Standard Libraries set YES

##### Swift Package Manager
From Xcode simply select `File > Swift Packages > Add Package Dependency...` and paste `https://github.com/network-international/cardmanagement-sdk-ios` to search field. You can specify rules according to your preferences and you are ready to use. 


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

###### Create NIInput model
Swift:
```swift
    let input = NIInput(bankCode: bankCode,
                        cardIdentifierId: cardIdentifierId,
                        cardIdentifierType: cardIdentifierType,
                        connectionProperties: NIConnectionProperties(rootUrl: rootUrl, token: token),
                        displayAttributes: NIDisplayAttributes(theme: .light, language: language))
    NICardManagementAPI.displayCardDetailsForm(input: input, viewController: self) { successResponse, errorResponse in
        // handle error and success
    }
```
###### Display attributes  
Display attributes parameter is optional. You can set one or more attributes, or even none of them.  

1. Theme
We support dark and light mode, by setting the theme parameter from the display attributes. If the Customer App is in dark mode, then you should use our SDK with dark theme. If the Customer App is in light mode, then you should use our SDK with light theme.  

2. Language
Languages supported are English and Arabic. You can either set the desired language or not. 
If you don’t set any language, it will use the device language, if supported, otherwise will default to English. 

3. Fonts
We support customization of fonts. System and custom fonts can be set for the labels of each form view.  

4. Card Attributes
Card Attributes is optional. It can be set if customisation of the card details view is wanted.   
We offer:  
    - Possibility to show or hide card details by default 
    To directly show the card details (not masked) when card view is displayed, we expect the ```shouldHide``` property to be set to false, otherwise to be set to false. If ```shouldHide``` property is not set, the default value is true.
    E.g.:  
    ```
    let cardAttributes = NICardAttributes(shouldHide: false) 
    ```

    - Background image customization 
    For the card background image, we expect a UIImage to be set. The recommended size would be 343 x 182. 
    E.g.:  
    ```
    let image = UIImage(named:"background_image") 
    let cardAttributes = NICardAttributes(backgroundImage: image)) 
    ```
    - Possibility to set the text position as grouped labels on card view
    The card details labels are grouped as follows: 
     - Card Number Group 
     - Expiry Date & CVV Group
     - Card Holder Name Group
     
    In order to set the position of the each group, we expect percentage (of card container view height and width) values to the following parameters: ```leftAlignment```, ```cardNumberGroupTopAlignment```, ```dateCvvGroupTopAlignment```, ```cardHolderNameGroupTopAlignment```
    E.g.:  
    ```
    let textPosition = NICardDetailsTextPositioning(leftAlignment: 0.09, cardNumberGroupTopAlignment: 0.4, dateCvvGroupTopAlignment: 0.6, cardHolderNameGroupTopAlignment: 0.8)
    let cardAttributes = NICardAttributes(textPositioning: textPosition)
    ```

    All are optional. 

    If all properties are wanted, initialization NICardAttributes is made with all properties. 
    E.g.:  
    ```
    let image = UIImage(named:"background_image") 
    let textPosition = NICardDetailsTextPositioning(leftAlignment: 0.09, cardNumberGroupTopAlignment: 0.4, dateCvvGroupTopAlignment: 0.6, cardHolderNameGroupTopAlignment: 0.8)
    let cardAttributes = NICardAttributes(shouldHide: false, backgroundImage: image, textPositioning: textPosition) 
    ```

#### Form Factory Interface
##### Display Card Details Form
The form interface will display the card details in a new screen (UIViewController).
The card info displayed are: Card Number, Expiry Date, CVV and Cardholder Name.

```swift
func displayCardDetailsForm(input: NICardManagementSDK.NIInput, viewController: UIViewController, completion: @escaping (NICardManagementSDK.NISuccessResponse?, NICardManagementSDK.NIErrorResponse?) -> Void)
```
Swift: 
```swift
    NICardManagementAPI.displayCardDetailsForm(input: input, viewController: self) { successResponse, errorResponse in
        // handle error and success
    }
```


##### Set PIN Form 
A PIN-pad will be displayed into a separate screen (UIViewController). 

Swift:
```swift
NICardManagementAPI.setPinForm(input: input, type: pinType, viewController: self) { successResponse, errorResponse in
	//  handle here error and success
}
```
or without specifying the type (pin length)
```swift
NICardManagementAPI.setPinForm(input: input, viewController: self) { successResponse, errorResponse in
	// handle here error and success
}
```


##### Change PIN Form 
A PIN-pad will be displayed into a separate screen (UIViewController).
Change PIN is a two step flow:
1.Capture current PIN 
2.Capture new PIN 

```swift
NICardManagementAPI.changePinForm(input: input, type: pinType, viewController: self) { successResponse, errorResponse in
	//  handle here error and success
}
```
or without specifying the type (pin length)
```swift
NICardManagementAPI.changePinForm(input: input, viewController: self) { successResponse, errorResponse in
	// handle here error and success
}
```


##### Verify PIN Form 
A PIN-pad will be displayed into a separate screen (UIViewController). 

Swift:
```swift
NICardManagementAPI.verifyPinForm(input: input, type: pinType, viewController: self) { successResponse, errorResponse in
    //  handle here error and success
}
```
or without specifying the type (pin length)
```swift
NICardManagementAPI.verifyPinForm(input: input, viewController: self) { successResponse, errorResponse in
    // handle here error and success
}
```
