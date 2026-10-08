import SwiftUI

/// Design tokens: 柔和紫色系玻璃拟态。
enum Theme {
    /// 主强调色：薰衣草紫。
    static let accent = Color(red: 0.482, green: 0.380, blue: 1.0)   // #7B61FF
    /// 深一档的主色。
    static let accentDeep = Color(red: 0.376, green: 0.286, blue: 0.898) // #6049E5
    /// 浅一档的主色。
    static let accentSoft = Color(red: 0.694, green: 0.639, blue: 1.0) // #B1A3FF

    /// 品牌主渐变（按钮 / 选中态 / 图标块）。
    static let accentGradient = LinearGradient(
        colors: [Color(red: 0.635, green: 0.545, blue: 1.0),
                 Color(red: 0.455, green: 0.353, blue: 0.976)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// 图标宫格用的多彩渐变。
    static let tileGradients: [LinearGradient] = [
        LinearGradient(colors: [Color(red: 0.678, green: 0.596, blue: 1.0), Color(red: 0.478, green: 0.373, blue: 0.984)], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color(red: 0.604, green: 0.776, blue: 1.0), Color(red: 0.376, green: 0.588, blue: 0.980)], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color(red: 1.0, green: 0.647, blue: 0.804), Color(red: 0.945, green: 0.435, blue: 0.686)], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color(red: 1.0, green: 0.788, blue: 0.541), Color(red: 0.976, green: 0.596, blue: 0.286)], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color(red: 0.541, green: 0.898, blue: 0.812), Color(red: 0.243, green: 0.741, blue: 0.639)], startPoint: .topLeading, endPoint: .bottomTrailing),
        LinearGradient(colors: [Color(red: 0.784, green: 0.643, blue: 1.0), Color(red: 0.576, green: 0.400, blue: 0.965)], startPoint: .topLeading, endPoint: .bottomTrailing),
    ]

    /// 取第 index 个图标渐变（循环）。
    static func tileGradient(_ index: Int) -> LinearGradient {
        tileGradients[((index % tileGradients.count) + tileGradients.count) % tileGradients.count]
    }

    /// 会员金色渐变。
    static let goldGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.804, blue: 0.435),
                 Color(red: 0.937, green: 0.616, blue: 0.259)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    enum Radius {
        static let standard: CGFloat = 12
        static let large: CGFloat = 18
        static let panel: CGFloat = 24
    }
}

/// Motion tokens.
enum AppAnimation {
    static let quick = Animation.easeOut(duration: 0.15)
    static let smooth = Animation.easeInOut(duration: 0.3)
    static let spring = Animation.spring(response: 0.35, dampingFraction: 0.8)
}

extension View {
    /// Glass background with a graceful material fallback.
    @ViewBuilder
    func compatGlass(interactive: Bool = false, in shape: some Shape) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(interactive ? .regular.interactive() : .regular, in: shape)
        } else {
            self.background(.ultraThinMaterial, in: shape)
        }
    }
}
