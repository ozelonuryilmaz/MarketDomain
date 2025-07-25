// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MarketDomain",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MarketDomain", targets: ["MarketDomain"])
    ],
    dependencies: [
        .package(url: "https://github.com/ozelonuryilmaz/MarketData", from: "1.0.8")
    ],
    targets: [
        .target(
            name: "MarketDomain",
            dependencies: [
                .product(name: "MarketData", package: "MarketData")
            ],
            path: "Sources/MarketDomain"
        ),
        .testTarget(
            name: "MarketDomainTests",
            dependencies: ["MarketDomain"]
        )
    ]
)
