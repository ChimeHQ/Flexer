// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Flexer",
    platforms: [
		.macOS(.v10_15),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6),
		.macCatalyst(.v13)
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

let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency")
]

for target in package.targets {
	var settings = target.swiftSettings ?? []
	settings.append(contentsOf: swiftSettings)
	target.swiftSettings = settings
}
