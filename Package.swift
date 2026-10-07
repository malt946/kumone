// swift-tools-version: 6.2
import PackageDescription

// 光遇身高查询 — iOS 应用核心包。
//
// 该包原为 Kumone（网易云音乐客户端）的共享核心，现已改造为
// 光遇身高查询 App 的 iOS-only 核心模块。内部模块名保留 `KumoneCore`
// 以避免牵动 Xcode 工程引用，后续可统一重命名。
let package = Package(
    name: "Kumone",
    defaultLocalization: "zh-Hans",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "KumoneCore", targets: ["KumoneCore"]),
    ],
    targets: [
        .target(
            name: "KumoneCore",
            path: "Sources/Kumone",
            exclude: ["Resources"],
            swiftSettings: [
                .swiftLanguageMode(.v5),
            ]
        ),
    ]
)
