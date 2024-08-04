# card-management-sdk-ios-sample-app
Sample application illustrating the use of the Card Management SDK for iOS

## Requirements
This project was configured with Xcode 15 and target iOS version 15.

## Installation
The project uses [CocoaPods](https://cocoapods.org/) package manager to attach SDK as a dependency,
- make sure cocoapods installed `sudo gem install cocoapods`
- Run `$ pod install --repo-update` in project directory

## Quick start
After compiling and starting sample app, check `settings` Tab and provide your credintials (ask development team for `client_secret`).
- use credential clientId / client_secret to fetch token by SDK
- or get token and use it in wrapper `TokenFetcherFactory.makeSimpleWrapper(tokenValue: "your token")`:
```
curl --location --request POST 'https://apitest.network.ae/CardServices/v2/Token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'client_id=6rxqcbjuejesgw95htm4r3vg' \
--data-urlencode 'client_secret=*******' \
--data-urlencode 'grant_type=client_credentials'
```

