// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "PortableTextRenderer",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "PortableTextRenderer",
            targets: ["PortableTextRenderer"]),
    ],
    dependencies: [
        // No external dependencies as per requirements
    ],
    targets: [
        .target(
            name: "PortableTextRenderer",
            dependencies: []),
        .testTarget(
            name: "PortableTextRendererTests",
            dependencies: ["PortableTextRenderer"]),
    ],
    swiftLanguageVersions: [.v5]
)
