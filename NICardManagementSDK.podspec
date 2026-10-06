Pod::Spec.new do |spec|

  spec.name         = "NICardManagementSDK"
  spec.version      = "2.1.8"
  spec.summary      = "SDKs to help card issuers to consume our APIs from iOS applications."
  spec.homepage     = "https://github.com/network-international/card-management-sdk-ios"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.author    = "Network International"
 
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.platform     = :ios
  spec.ios.deployment_target = "15.0"
  spec.swift_version = "5.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source       = { :git => "https://github.com/network-international/card-management-sdk-ios.git", :tag => "#{spec.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source_files  = [
    "CardManagementSDK/Public/**/*.swift",
    "CardManagementSDK/Source/Coordinator/**/*.swift",
    "CardManagementSDK/Source/Views/**/*.swift",
    "CardManagementSDK/Source/Utils/**/*.swift"
  ]

  # Core is SPM-only (NICardManagementSDKCore). Not a CocoaPods product.
  # Local Example: build Core (`card-management-sdk-core/scripts/build-ios.sh`) then
  # `scripts/link-core.sh` so Vendor/NICardManagementSDKCore.xcframework exists.
  core_xcframework = File.expand_path("Vendor/NICardManagementSDKCore.xcframework", __dir__)
  if File.directory?(core_xcframework)
    spec.vendored_frameworks = "Vendor/NICardManagementSDKCore.xcframework"
  else
    Pod::UI.warn "NICardManagementSDK: Core XCFramework not found at Vendor/NICardManagementSDKCore.xcframework. Build card-management-sdk-core (scripts/build-ios.sh) and run scripts/link-core.sh. Core is not distributed via CocoaPods."
  end

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.resources = [
    "CardManagementSDK/Source/Views/**/*.xib"
  ]

  spec.resource_bundles = {
    "NICardManagementSDKResources" => [
      "CardManagementSDK/Source/Utils/Assets.xcassets",
      "CardManagementSDK/Source/Views/**/*.xib"
    ]
  }


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.frameworks = "UIKit", "Foundation"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.requires_arc = true

end
