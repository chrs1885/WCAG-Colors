// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v11)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.51.13"),
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.52.4"),
        .package(url: "https://github.com/orta/Komondor", from: "1.1.4"),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)

#if canImport(PackageConfig)
    import PackageConfig

    let config = PackageConfiguration([
        "komondor": [
            "pre-commit": [
                // "swift run swiftlint ../ --config ../.swiftlint",
                "swift run swiftformat ../ --config ../.swiftformat",
            ],
        ],
    ]).write()
#endif
