// swift-tools-version: 5.9
import PackageDescription
import Foundation

func resolveCoreDependency() -> Package.Dependency {
    let fm = FileManager.default
    let env = ProcessInfo.processInfo.environment["CORE_IOS_DIR"]
    let localCandidates = [
        env,
        "Vendor/NICardManagementSDKCore",
        "../../card-management-sdk-core/card-management-sdk-core/ios",
        "../card-management-sdk-core/card-management-sdk-core/ios",
        "../card-management-sdk-core/ios",
    ].compactMap { $0 }
    if let path = localCandidates.first(where: {
        fm.fileExists(atPath: $0 + "/Package.swift")
    }) {
        return .package(path: path)
    }
    // Temporary personal host until org Core repo exists (private — needs GitHub auth).
    return .package(
        url: "https://github.com/akiselevn/card-management-sdk-core.git",
        exact: "0.1.0"
    )
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
        resolveCoreDependency(),
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
