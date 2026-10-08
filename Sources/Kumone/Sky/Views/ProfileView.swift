import Foundation
import SwiftUI

/// 我的页：个人信息、会员状态与设置入口。
struct ProfileView: View {
    @EnvironmentObject private var session: SkySession
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var toasts: AppToastCenter
    @Environment(\.openURL) private var openURL

    private static let feedbackEmail = "3498741040@qq.com"

    @State private var showEditName = false
    @State private var draftName = ""
    @State private var showAgreement = false
    @State private var showPrivacy = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                profileHeader
                membershipCard
                settingsSection
                Color.clear.frame(height: SkyAppRoot.tabBarClearance)
            }
            .padding(16)
        }
        .background(background)
        .navigationTitle("我的")
        .alert("修改昵称", isPresented: $showEditName) {
            TextField("昵称", text: $draftName)
            Button("确定") {
                let name = draftName.trimmingCharacters(in: .whitespaces)
                if !name.isEmpty { session.nickname = name }
            }
            Button("取消", role: .cancel) {}
        }
        .sheet(isPresented: $showAgreement) { LegalDocumentView(kind: .agreement) }
        .sheet(isPresented: $showPrivacy) { LegalDocumentView(kind: .privacy) }
    }

    // MARK: - Header

    private var profileHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Theme.accentGradient)
                    .frame(width: 60, height: 60)
                Text(String(session.nickname.prefix(1)))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(session.nickname)
                        .font(.system(size: 18, weight: .semibold))
                    if session.isVIP {
                        SkyBadge(text: "VIP")
                    }
                }
                Text(session.accountID)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                draftName = session.nickname
                showEditName = true
            } label: {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.accent)
                    .padding(10)
                    .background(Theme.accent.opacity(0.12), in: Circle())
            }
        }
    }

    // MARK: - Membership

    private var membershipCard: some View {
        SkyCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label("会员状态", systemImage: "crown.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(session.isVIP ? Theme.accent : .primary)
                    Spacer()
                    if session.isVIP {
                        SkyBadge(text: "生效中")
                    } else if session.isExpired {
                        SkyBadge(text: "已过期", tint: .secondary)
                    } else {
                        SkyBadge(text: "未开通", tint: .secondary)
                    }
                }

                if session.isVIP {
                    infoRow(label: "到期时间", value: formatSeconds(session.membershipExpiry))
                    if let days = session.remainingDays {
                        infoRow(label: "剩余天数", value: "\(days) 天")
                    }
                } else if session.isExpired {
                    Text("你的会员已于 \(formatSeconds(session.membershipExpiry)) 到期。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("尚未开通会员，开通后可解锁全部功能与高级工具。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                NavigationLink {
                    SkyMembershipDetailView()
                } label: {
                    Text("详情")
                }
                .buttonStyle(detailButtonStyle)
            }
        }
    }

    private func infoRow(label: LocalizedStringKey, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
        }
    }

    private var detailButtonStyle: some ButtonStyle {
        if session.isVIP {
            return AnyButtonStyle(SkySecondaryButtonStyle())
        }
        return AnyButtonStyle(SkyPrimaryButtonStyle())
    }

    private func formatSeconds(_ date: Date?) -> String {
        guard let date else { return "—" }
        return skyDateTimeSecondsText(date)
    }

    // MARK: - Settings

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkySectionHeader(title: "设置")

            SkyCard(padding: 0) {
                VStack(spacing: 0) {
                    appearanceRow
                    divider
                    actionRow(icon: "trash", title: "清除缓存") {
                        toasts.show("缓存已清除")
                    }
                    divider
                    actionRow(icon: "envelope", title: "意见反馈") {
                        openFeedback()
                    }
                    divider
                    actionRow(icon: "info.circle", title: "关于我们") {
                        toasts.show("光遇身高查询 1.0.0")
                    }
                    divider
                    actionRow(icon: "doc.text", title: "用户协议") {
                        showAgreement = true
                    }
                    divider
                    actionRow(icon: "hand.raised", title: "隐私政策") {
                        showPrivacy = true
                    }
                }
            }
        }
    }

    private var appearanceRow: some View {
        Menu {
            Picker("外观", selection: $settings.appearance) {
                ForEach(SkyAppearance.allCases) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
        } label: {
            HStack(spacing: 10) {
                settingIcon("circle.lefthalf.filled")
                Text("外观")
                    .font(.system(size: 15))
                    .foregroundStyle(.primary)
                Spacer()
                Text(settings.appearance.displayName)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func actionRow(icon: String, title: LocalizedStringKey, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                settingIcon(icon)
                Text(title)
                    .font(.system(size: 15))
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 13)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func openFeedback() {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = Self.feedbackEmail
        components.queryItems = [
            URLQueryItem(name: "subject", value: "光遇身高查询 · 意见反馈")
        ]
        guard let url = components.url else {
            toasts.show("无法打开邮箱：\(Self.feedbackEmail)")
            return
        }
        openURL(url) { accepted in
            if !accepted {
                toasts.show("未找到邮箱应用，请联系 \(Self.feedbackEmail)")
            }
        }
    }

    private func settingIcon(_ name: String) -> some View {
        Image(systemName: name)
            .font(.system(size: 15))
            .foregroundStyle(.primary)
            .frame(width: 22, alignment: .center)
    }

    private var divider: some View {
        Divider().padding(.leading, 14)
    }

    private var background: some View {
        Color(.systemGroupedBackground).ignoresSafeArea()
    }
}
