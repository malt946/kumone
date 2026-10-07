import SwiftUI

/// Design tokens: color, radius, spacing, layout metrics.
enum Theme {
    /// 应用主色：温暖的珊瑚红。
    static let accent = Color(red: 0.925, green: 0.286, blue: 0.286) // #EC4949
    static let accentDeep = Color(red: 0.788, green: 0.161, blue: 0.161) // #C92929

    static let accentGradient = LinearGradient(
        colors: [Color(red: 0.973, green: 0.357, blue: 0.357), accentDeep],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )

    enum Radius {
        static let standard: CGFloat = 8
        static let large: CGFloat = 12
        static let panel: CGFloat = 20
    }
}

/// Motion tokens.
enum AppAnimation {
    static let quick = Animation.easeOut(duration: 0.15)
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
