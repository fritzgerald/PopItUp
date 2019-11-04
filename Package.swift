// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "PopItUp",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(name: "PopItUp", targets: ["PopItUp"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "PopItUp", dependencies: []),
    ]
)
