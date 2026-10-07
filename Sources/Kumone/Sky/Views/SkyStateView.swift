import SwiftUI

/// 通用页面状态占位视图：空数据、加载中、错误三种形态统一呈现。
///
/// 用法：
/// - `SkyStateView.empty(title:message:actionTitle:action:)`
/// - `SkyStateView.loading("查询中…")`
/// - `SkyStateView.error(title:message:retry:)`
struct SkyStateView: View {
    enum Kind: Equatable {
        case empty
        case loading
        case error

        var icon: String {
            switch self {
            case .empty: return "tray"
            case .loading: return "arrow.triangle.2.circlepath"
            case .error: return "exclamationmark.triangle.fill"
            }
        }

        var tint: Color {
            switch self {
            case .empty: return .secondary
            case .loading: return Theme.accent
            case .error: return .orange
            }
        }
    }

    let kind: Kind
    var icon: String?
    var title: LocalizedStringKey
    var message: LocalizedStringKey?
    var actionTitle: LocalizedStringKey?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            symbol
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)
            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(SkySecondaryButtonStyle())
                    .frame(maxWidth: 220)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var symbol: some View {
        if kind == .loading {
            ProgressView()
                .tint(kind.tint)
                .scaleEffect(1.3)
                .frame(width: 52, height: 52)
        } else {
            Image(systemName: icon ?? kind.icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(kind.tint)
                .frame(width: 52, height: 52)
                .background(kind.tint.opacity(0.12), in: Circle())
        }
    }
}

extension SkyStateView {
    static func empty(
        title: LocalizedStringKey,
        message: LocalizedStringKey? = nil,
        icon: String? = nil,
        actionTitle: LocalizedStringKey? = nil,
        action: (() -> Void)? = nil
    ) -> SkyStateView {
        SkyStateView(kind: .empty, icon: icon, title: title, message: message, actionTitle: actionTitle, action: action)
    }

    static func loading(_ title: LocalizedStringKey, message: LocalizedStringKey? = nil) -> SkyStateView {
        SkyStateView(kind: .loading, icon: nil, title: title, message: message, actionTitle: nil, action: nil)
    }

    static func error(
        title: LocalizedStringKey = "出错了",
        message: LocalizedStringKey?,
        retry: (() -> Void)? = nil
    ) -> SkyStateView {
        SkyStateView(
            kind: .error,
            icon: nil,
            title: title,
            message: message,
            actionTitle: retry == nil ? nil : "重试",
            action: retry
        )
    }
}
