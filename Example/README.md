# card-management-sdk-ios-sample-app
Sample application illustrating the use of the Card Management SDK for iOS

## Requirements
- Xcode 15+ (deployment target iOS 15; Example uses iOS 17)
- Swift Package Manager (this Example does not use CocoaPods; Trunk goes read-only on [2 December 2026](https://blog.cocoapods.org/CocoaPods-Specs-Repo/))

## Installation

The Example app depends on the local SPM package at the repository root (`Package.swift` → product `NICardManagementSDK`). Core is a transitive SPM dependency.

1. From the repository root, ensure Core can resolve:
   - **Remote (default):** GitHub auth to private [`akiselevn/card-management-sdk-core`](https://github.com/akiselevn/card-management-sdk-core) (e.g. `gh auth` / `CORE_GITHUB_TOKEN` / netrc), then `swift package resolve`
   - **Local Core:** `CORE_USE_LOCAL=1` and `./scripts/link-core.sh`
2. Open the Example **project** (not a CocoaPods workspace):

```bash
open Example/CardManagementSDKSwiftSample.xcodeproj
```

3. Build & run the `CardManagementSDKSwiftSample` scheme.

App integrators consuming a published UI SDK do **not** add Core separately.

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
