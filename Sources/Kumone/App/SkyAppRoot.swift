import SwiftUI

/// 应用根视图：四个主 Tab + 悬浮 Tab 栏 + 首次启动协议弹窗。
public struct SkyAppRoot: View {
    @StateObject private var settings = AppSettings.shared
    @StateObject private var session = SkySession.shared
    @StateObject private var queryStore = SkyQueryStore.shared
    @StateObject private var toasts = AppToastCenter.shared

    @State private var selectedTab: AppTab = .query

    /// 内容需要为悬浮 Tab 栏预留的底部空间。
    static let tabBarClearance: CGFloat = 96

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            SkyTabBar(items: SkyTabBar.items, selection: $selectedTab)
                .padding(.bottom, 6)
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .environmentObject(settings)
        .environmentObject(session)
        .environmentObject(queryStore)
        .environmentObject(toasts)
        .tint(Theme.accent)
        .preferredColorScheme(settings.appearance.colorScheme)
        .overlay(alignment: .top) {
            if let toast = toasts.current {
                AppToastView(toast: toast)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 8)
            }
        }
        .animation(.spring(duration: 0.3), value: toasts.current)
        .fullScreenCover(isPresented: agreementBinding) {
            OnboardingView()
                .environmentObject(settings)
                .tint(Theme.accent)
                .preferredColorScheme(settings.appearance.colorScheme)
                .interactiveDismissDisabled()
        }
    }

    /// 未同意协议时弹出；同意后自动收起。
    private var agreementBinding: Binding<Bool> {
        Binding(
            get: { !settings.hasAcceptedAgreement },
            set: { _ in }
        )
    }

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .query:
            NavigationStack { QueryView() }
        case .tools:
            NavigationStack { ToolsView() }
        case .store:
            NavigationStack { StoreView() }
        case .profile:
            NavigationStack { ProfileView() }
        }
    }
}
