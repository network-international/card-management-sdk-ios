Pod::Spec.new do |spec|

  spec.name         = "NICardManagementSDK"
  spec.version      = "1.0.0"
  spec.summary      = "SDKs to help card issuers to consume our APIs from iOS applications."
  spec.homepage     = "https://github.com/network-international/card-management-sdk-ios"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.author    = "Network International"
 
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.platform     = :ios
  spec.ios.deployment_target = "12.0"
  spec.swift_version = "5.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source       = { :git => "https://github.com/network-international/card-management-sdk-ios.git", :tag => "#{spec.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source_files  = "CardManagementSDK/**/*.{swift}"

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.resources = "CardManagementSDK/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.frameworks = "UIKit", "Foundation"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.requires_arc = true

end
