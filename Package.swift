// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Flexer",
    platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6),
		.macCatalyst(.v13),
		.visionOS(.v1)
	],
    products: [
        .library(name: "Flexer", targets: ["Flexer"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "Flexer", dependencies: []),
        .testTarget(name: "FlexerTests", dependencies: ["Flexer"]),
    ]
)
