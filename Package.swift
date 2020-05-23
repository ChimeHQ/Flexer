// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Flexer",
    platforms: [.macOS(.v10_12), .iOS(.v10)],
    products: [
        .library(name: "Flexer", targets: ["Flexer"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Flexer", dependencies: [], path: "Flexer/"),
        .testTarget(name: "FlexerTests", dependencies: ["Flexer"], path: "FlexerTests/"),
    ]
)
