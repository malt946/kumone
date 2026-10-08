import SwiftUI

/// 收银台整页：选择支付方式并完成会员开通。
struct SkyPaymentView: View {
    let plan: MembershipPlan

    @EnvironmentObject private var session: SkySession
    @EnvironmentObject private var orderStore: SkyOrderStore
    @EnvironmentObject private var toasts: AppToastCenter
    @Environment(\.dismiss) private var dismiss

    @State private var method: PaymentMethod = .wechat
    @State private var isPaying = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                amountCard
                methodSection
                paySection
                Color.clear.frame(height: SkyAppRoot.tabBarClearance)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("收银台")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }

    // MARK: - Amount

    private var amountCard: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: Theme.Radius.panel, style: .continuous)
                .fill(Theme.accentGradient)

            HStack(spacing: 14) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(.white.opacity(0.18), in: Circle())

                VStack(alignment: .leading, spacing: 5) {
                    Text(plan.title)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                    Text(plan.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(skyPriceText(plan.price))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    if let original = plan.originalPrice {
                        Text(skyPriceText(original))
                            .font(.caption2)
                            .strikethrough()
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }
            .padding(20)
        }
    }

    // MARK: - Methods

    private var methodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkySectionHeader(title: "选择支付方式")

            ForEach(PaymentMethod.allCases) { option in
                methodRow(option)
            }
        }
    }

    private func methodRow(_ option: PaymentMethod) -> some View {
        let isSelected = option == method
        return Button {
            withAnimation(AppAnimation.quick) { method = option }
        } label: {
            HStack(spacing: 14) {
                Image(option.iconAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)

                VStack(alignment: .leading, spacing: 3) {
                    Text(option.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(option.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? Theme.accent : .secondary.opacity(0.4), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle().fill(Theme.accent).frame(width: 12, height: 12)
                    }
                }
            }
            .padding(14)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Theme.Radius.large, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: Theme.Radius.large, style: .continuous)
                    .strokeBorder(isSelected ? Theme.accent : .primary.opacity(0.06),
                                  lineWidth: isSelected ? 1.5 : 0.5)
            }
        }
        .buttonStyle(.plain)
        .disabled(isPaying)
    }

    // MARK: - Pay

    private var paySection: some View {
        VStack(spacing: 10) {
            Button {
                pay()
            } label: {
                HStack(spacing: 8) {
                    if isPaying {
                        ProgressView().tint(.white)
                    }
                    Text(isPaying ? "支付中…" : "确认支付 \(skyPriceText(plan.price))")
                }
            }
            .buttonStyle(SkyPrimaryButtonStyle())
            .disabled(isPaying)

            Text("点击确认即视为同意《会员服务协议》，虚拟商品开通后不支持退款。")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }

    private func pay() {
        guard !isPaying else { return }
        isPaying = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            session.activate(plan)
            orderStore.add(plan: plan, method: method)
            toasts.show("开通成功：\(plan.title)（\(method.title)）")
            dismiss()
        }
    }
}
