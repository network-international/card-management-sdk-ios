// swift-tools-version: 5.9
import PackageDescription
import Foundation

func resolveCorePath() -> String {
    let fm = FileManager.default
    let env = ProcessInfo.processInfo.environment["CORE_IOS_DIR"]
    let candidates = [
        env,
        "Vendor/NICardManagementSDKCore",
        "../../card-management-sdk-core/card-management-sdk-core/ios",
        "../card-management-sdk-core/card-management-sdk-core/ios",
        "../card-management-sdk-core/ios",
    ].compactMap { $0 }
    guard let path = candidates.first(where: {
        fm.fileExists(atPath: $0 + "/Package.swift")
    }) else {
        fatalError("Core iOS package not found. Clone card-management-sdk-core and run scripts/link-core.sh (or set CORE_IOS_DIR).")
    }
    return path
}

let xibs = (try? FileManager.default.subpathsOfDirectory(atPath: "CardManagementSDK"))?
    .filter { $0.hasSuffix(".xib") }
    .map { Resource.process($0) } ?? []

let package = Package(
    name: "NICardManagementSDK",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "NICardManagementSDK",
            targets: ["NICardManagementSDK"]
        ),
    ],
    dependencies: [
        .package(path: resolveCorePath()),
    ],
    targets: [
        .target(
            name: "NICardManagementSDK",
            dependencies: [
                .product(name: "NICardManagementSDKCore", package: "NICardManagementSDKCore"),
            ],
            path: "CardManagementSDK",
            exclude: [
                "CardManagementSDK.h",
                "CardManagementSDK.docc",
            ],
            resources: [
                .process("Source/Utils/Assets.xcassets"),
            ] + xibs
        ),
    ]
)
