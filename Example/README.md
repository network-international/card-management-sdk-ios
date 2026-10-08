# card-management-sdk-ios-sample-app
Sample application illustrating the use of the Card Management SDK for iOS

## Requirements
- Xcode 15+ (deployment target iOS 15; Example Podfile uses iOS 17)
- CocoaPods
- Private **Core** XCFramework for local `:path` SDK builds (CocoaPods vendors `Vendor/NICardManagementSDKCore.xcframework`)

## Installation

From the **repository root** (not `Example/`), fetch Core **0.1.0** into `Vendor/` (needs `gh` auth or `CORE_GITHUB_TOKEN` with read access to [`akiselevn/card-management-sdk-core`](https://github.com/akiselevn/card-management-sdk-core)):

```bash
bash scripts/fetch-core-xcframework.sh
```

Or build Core locally and link it:

```bash
# in card-management-sdk-core
bash scripts/build-ios.sh
# in this repo
bash scripts/link-core.sh
```

Then install pods and open the workspace:

```bash
cd Example
pod install
open CardManagementSDKSwiftSample.xcworkspace
```

App integrators do **not** add Core separately when consuming a published UI SDK — Core is already bundled/transitive. The Vendor step is for **this Example** (local pod `:path => '../'`).

Alternatively, you may consume the SDK as a binary XCFramework by downloading a release package from GitHub Releases and adding `NICardManagementSDK.xcframework` directly to your app.

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

