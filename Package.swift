// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ghbalmungcore",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "ghbalmungcore",
            targets: ["ghbalmungcore"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
                .upToNextMajor(from: "5.4.0")
        ),
        .package(
            url: "https://gitlab.com/l159/ios/dependencies/global/gnswissrazor.git",
                .branch("main")
        )
    ],
    targets: [
        .target(
            name: "ghbalmungcore",
            dependencies: []),
        .testTarget(
            name: "ghbalmungcoreTests",
            dependencies: ["ghbalmungcore"]),
    ]
)
