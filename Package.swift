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
//        TODO: Global
//        .package(
//            url: "https://gitlab.com/styme1/mobile/ios/dependencies/ghgungnircore.git",
//            branch: "main"
//        )
//        TODO: GoNet
//        .package(
//           url: "https://git.gonet.us/gnglobaldependencies/ios/ghgungnircore.git",
//           branch: "main"
//        )
//        TODO: Github
//        .package(
//            url: "https://github.com/StyMe-IOS/ghgungnircore.git",
//            branch: "main"
//        )
//        TODO: HA
        .package(
            url: "https://github.com/HAFootprint/ghgungnircore.git",
            branch: "main"
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
                "Alamofire"
            ]
        ),
        .target(
            name: "ghurlsessioncore",
            dependencies: [
                "ghbalmungcore"
            ]
        ),
        .target(
            name: "ghurlsessioncombine",
            dependencies: [
                "ghbalmungcore"
            ]
        ),
        .testTarget(
            name: "ghbalmungcoreTests",
            dependencies: [
                "ghbalmungcore",
                "ghalamocore",
                "ghurlsessioncore",
                "ghurlsessioncombine"
            ]
        ),
    ]
)
