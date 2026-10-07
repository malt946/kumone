import SwiftUI

/// 首次启动引导：展示品牌与核心功能，并要求同意用户协议与隐私政策。
struct OnboardingView: View {
    @EnvironmentObject private var settings: AppSettings

    @State private var agreed = false
    @State private var showRefuseAlert = false
    @State private var showAgreement = false
    @State private var showPrivacy = false

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                Spacer(minLength: 24)

                logo
                titleBlock
                featureList

                Spacer(minLength: 24)

                footer
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
        }
        .alert("需先同意协议", isPresented: $showRefuseAlert) {
            Button("好的", role: .cancel) {}
        } message: {
            Text("同意《用户协议》与《隐私政策》后才能使用本应用。")
        }
        .sheet(isPresented: $showAgreement) { LegalDocumentView(kind: .agreement) }
        .sheet(isPresented: $showPrivacy) { LegalDocumentView(kind: .privacy) }
    }

    // MARK: - Brand

    private var logo: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Theme.accentGradient)
                .frame(width: 96, height: 96)
                .shadow(color: Theme.accent.opacity(0.35), radius: 18, y: 8)
            Image(systemName: "figure.walk.motion")
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.bottom, 22)
    }

    private var titleBlock: some View {
        VStack(spacing: 8) {
            Text("光遇身高查询")
                .font(.system(size: 26, weight: .bold))
            Text("查询好友身高体型，解锁更多实用工具")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 28)
    }

    private var featureList: some View {
        VStack(spacing: 14) {
            featureRow(icon: "magnifyingglass.circle.fill", text: "一键查询光遇角色身高与体型")
            featureRow(icon: "wrench.and.screwdriver.fill", text: "身高换算、蜡烛计算等实用工具")
            featureRow(icon: "crown.fill", text: "会员解锁无限查询与全部高级功能")
        }
    }

    private func featureRow(icon: String, text: LocalizedStringKey) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.accent)
                .frame(width: 32, height: 32)
                .background(Theme.accent.opacity(0.12), in: Circle())
            Text(text)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Footer

    private var footer: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                HStack(spacing: 6) {
                    Button {
                        agreed.toggle()
                    } label: {
                        Image(systemName: agreed ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 20))
                            .foregroundStyle(agreed ? Theme.accent : Color.secondary)
                    }
                    .buttonStyle(.plain)

                    Text("我已阅读并同意")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 4) {
                    Button("《用户协议》") { showAgreement = true }
                        .font(.footnote)
                        .foregroundStyle(Theme.accent)
                    Text("和")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Button("《隐私政策》") { showPrivacy = true }
                        .font(.footnote)
                        .foregroundStyle(Theme.accent)
                }
            }

            Button("同意并继续") {
                settings.acceptAgreement()
            }
            .buttonStyle(SkyPrimaryButtonStyle())
            .disabled(!agreed)
            .opacity(agreed ? 1 : 0.5)

            Button("不同意") {
                showRefuseAlert = true
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
    }

    private var background: some View {
        ZStack {
            Color(.systemBackground)
            RadialGradient(
                colors: [Theme.accent.opacity(0.18), .clear],
                center: .top,
                startRadius: 0,
                endRadius: 520
            )
        }
        .ignoresSafeArea()
    }
}

// MARK: - Legal documents

enum LegalDocumentKind {
    case agreement
    case privacy

    var title: LocalizedStringKey {
        switch self {
        case .agreement: return "用户协议"
        case .privacy: return "隐私政策"
        }
    }

    var updatedAt: String { "2026-01-01" }

    var sections: [(String, String)] {
        switch self {
        case .agreement:
            return [
                ("一、服务说明", "本应用为《光·遇》玩家提供身高查询与辅助工具服务，与游戏官方无任何关联。所有查询结果仅供参考，不作为任何交易或承诺的依据。"),
                ("二、账号与会员", "你可在本应用内开通会员以解锁更多功能。会员为虚拟数字商品，开通后即时生效，除法律另有规定外不支持退款。"),
                ("三、用户行为规范", "你承诺不利用本应用从事任何违法、侵权或破坏服务正常运行的行为。因违规使用导致的后果由你自行承担。"),
                ("四、免责声明", "本应用按「现状」提供，我们尽力保证服务稳定与数据准确，但不对因使用本应用产生的任何间接损失承担责任。"),
                ("五、协议变更", "我们可能适时更新本协议，更新后将在应用内提示。你继续使用即视为接受更新后的协议。"),
            ]
        case .privacy:
            return [
                ("一、信息收集", "为提供查询服务，我们可能收集你主动填写的昵称、好友码等必要信息。我们不会收集与提供服务无关的个人信息。"),
                ("二、信息使用", "收集的信息仅用于实现查询、历史记录同步与会员权益等功能，不会用于其他用途。"),
                ("三、信息存储", "查询记录默认保存在你的设备本地。若你开通会员并使用云同步，相关信息将加密传输与存储。"),
                ("四、信息共享", "除法律法规要求或你明确授权外，我们不会向任何第三方出售或共享你的个人信息。"),
                ("五、你的权利", "你可以随时在应用内清除本地缓存与查询记录，或停止使用本应用以终止信息处理。"),
            ]
        }
    }
}

/// 协议正文页，以 Sheet 形式展示。
struct LegalDocumentView: View {
    let kind: LegalDocumentKind

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("生效日期：\(kind.updatedAt)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    ForEach(Array(kind.sections.enumerated()), id: \.offset) { _, section in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.0)
                                .font(.headline)
                            Text(section.1)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle(kind.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}
