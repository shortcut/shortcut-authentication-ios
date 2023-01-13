// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShortcutAuthentication",
    platforms: [
        .iOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ShortcutAuthentication",
            targets: [
                "AppleIdSignIn",
                "GoogleIdSignIn"
            ]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", .upToNextMajor(from: "7.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppleIdSignIn",
            dependencies: [],
            path: "AppleIdSignIn/Sources"
        ),
        .testTarget(
            name: "AppleIdSignInTests",
            dependencies: ["AppleIdSignIn"],
            path: "AppleIdSignIn/Tests"
        ),
        .target(
            name: "GoogleIdSignIn",
            dependencies: [
                .product(name: "GoogleSignIn", package: "googlesignin-ios")
            ],
            path: "GoogleIdSignIn/Sources"
        ),
        .testTarget(
            name: "GoogleIdSignInTests",
            dependencies: ["GoogleIdSignIn"],
            path: "GoogleIdSignIn/Tests"
        )
    ]
)
