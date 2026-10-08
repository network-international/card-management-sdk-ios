// swift-tools-version: 5.9
import PackageDescription
import Foundation

/// Remote URL identity is the repo name (`card-management-sdk-core`).
/// Local path identity is Package.swift `name` (`NICardManagementSDKCore`).
struct CorePin {
    let dependency: Package.Dependency
    let packageIdentity: String
}

func resolveCorePin() -> CorePin {
    let env = ProcessInfo.processInfo.environment
    let useLocal = env["CORE_USE_LOCAL"] == "1" || env["CORE_IOS_DIR"] != nil
    if useLocal {
        let fm = FileManager.default
        let candidates = [
            env["CORE_IOS_DIR"],
            "Vendor/NICardManagementSDKCore",
        ].compactMap { $0 }
        if let path = candidates.first(where: { fm.fileExists(atPath: $0 + "/Package.swift") }) {
            return CorePin(
                dependency: .package(path: path),
                packageIdentity: "NICardManagementSDKCore"
            )
        }
        fatalError("CORE_USE_LOCAL/CORE_IOS_DIR set but Core Package.swift not found. Run scripts/link-core.sh or set CORE_IOS_DIR.")
    }
    // Phase 5 default: hosted Core binary (private — GitHub auth / netrc required).
    return CorePin(
        dependency: .package(
            url: "https://github.com/akiselevn/card-management-sdk-core.git",
            exact: "0.1.0"
        ),
        packageIdentity: "card-management-sdk-core"
    )
}

let core = resolveCorePin()

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
        core.dependency,
    ],
    targets: [
        .target(
            name: "NICardManagementSDK",
            dependencies: [
                .product(name: "NICardManagementSDKCore", package: core.packageIdentity),
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
