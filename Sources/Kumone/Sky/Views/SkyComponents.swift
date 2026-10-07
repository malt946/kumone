import Foundation
import SwiftUI

/// 统一卡片容器：圆角 + 半透明材质 + 细边框。
struct SkyCard<Content: View>: View {
    var cornerRadius: CGFloat = Theme.Radius.large
    var padding: CGFloat = 16
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(.primary.opacity(0.06), lineWidth: 0.5)
            }
    }
}

/// 区块标题。
struct SkySectionHeader: View {
    let title: LocalizedStringKey

    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// 小标签（体型 / 徽章）。
struct SkyBadge: View {
    let text: String
    var tint: Color = Theme.accent

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(tint.opacity(0.15), in: Capsule())
            .foregroundStyle(tint)
    }
}

/// 主按钮样式。
struct SkyPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Theme.accentGradient, in: RoundedRectangle(cornerRadius: Theme.Radius.standard, style: .continuous))
            .opacity(configuration.isPressed ? 0.82 : 1)
    }
}

/// 次按钮样式。
struct SkySecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(Theme.accent)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Theme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: Theme.Radius.standard, style: .continuous))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

/// 金额格式化，整数不显示小数。
func skyPriceText(_ value: Double) -> String {
    if value == value.rounded() {
        return String(format: "￥%.0f", value)
    }
    return String(format: "￥%.2f", value)
}
