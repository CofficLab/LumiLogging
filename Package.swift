// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LumiLogging",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "LumiLoggingKit", targets: ["LumiLoggingKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CofficLab/LumiLocalization.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "LumiLoggingKit",
            dependencies: [
                .product(name: "LumiLocalizationKit", package: "LumiLocalization"),
            ]
        ),
    ]
)
