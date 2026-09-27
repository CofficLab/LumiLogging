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
    targets: [
        .target(name: "LumiLoggingKit"),
    ]
)
