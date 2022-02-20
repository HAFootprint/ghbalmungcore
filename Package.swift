// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ghbalmungcore",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "ghbalmungcore",
            targets: [
                "ghbalmungcore"
            ]
        ),
        .library(
            name: "ghalamocore",
            targets: [
                "ghbalmungcore",
                "ghalamocore"
            ]
        ),
        .library(
            name: "ghurlsessioncore",
            targets: [
                "ghbalmungcore",
                "ghurlsessioncore"
            ]
        ),
        .library(
            name: "ghurlsessioncombine",
            targets: [
                "ghbalmungcore",
                "ghurlsessioncombine"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
                .upToNextMajor(from: "5.4.0")
        ),
        .package(
            url: "https://git.gonet.us/gnglobaldependencies/ios/ghgungnircore.git",
                .branch("main")
        )
    ],
    targets: [
        .target(
            name: "ghbalmungcore",
            dependencies: [
                "ghgungnircore"
            ],
            exclude:[
                "resources/GHGlobalServiceConfig-info.json"
            ]
        ),
        .target(
            name: "ghalamocore",
            dependencies: [
                "ghbalmungcore",
                "Alamofire",
                "ghgungnircore"
            ]
        ),
        .target(
            name: "ghurlsessioncore",
            dependencies: [
                "ghbalmungcore",
                "ghgungnircore"
            ]
        ),
        .target(
            name: "ghurlsessioncombine",
            dependencies: [
                "ghbalmungcore",
                "ghgungnircore"
            ]
        ),
        .testTarget(
            name: "ghbalmungcoreTests",
            dependencies: [
                "ghbalmungcore"
            ]
        ),
    ]
)
