// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WCAG-Colors",
    platforms: [
        .macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WCAG-Colors",
            targets: ["WCAG-Colors"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "7.1.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "12.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WCAG-Colors",
            dependencies: []
        ),
        .testTarget(
            name: "WCAG-ColorsTests",
            dependencies: ["WCAG-Colors", "Quick", "Nimble"],
            linkerSettings: [
                .linkedFramework("AppKit", .when(platforms: [.macOS])),
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS, .watchOS]))
                ]
                
        ),
    ],
    swiftLanguageVersions: [.v5]
)
