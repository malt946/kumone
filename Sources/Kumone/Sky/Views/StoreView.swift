import SwiftUI

/// 商城页：会员权益展示与套餐开通。
struct StoreView: View {
    @EnvironmentObject private var session: SkySession
    @EnvironmentObject private var toasts: AppToastCenter

    @State private var selectedPlanID: String = MembershipPlan.all.dropFirst().first?.id ?? ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                statusHeader
                benefitsSection
                plansSection
                footer
                Color.clear.frame(height: SkyAppRoot.tabBarClearance)
            }
            .padding(16)
        }
        .background(background)
        .navigationTitle("商城")
    }

    // MARK: - Status

    private var statusHeader: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: Theme.Radius.panel, style: .continuous)
                .fill(Theme.accentGradient)

            HStack(spacing: 14) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(.white.opacity(0.18), in: Circle())

                VStack(alignment: .leading, spacing: 5) {
                    Text(session.isVIP ? "会员生效中" : "开通会员")
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(.white)
                    Text(statusSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                }

                Spacer()
            }
            .padding(20)
        }
    }

    private var statusSubtitle: String {
        if session.isVIP {
            if let days = session.remainingDays {
                return "剩余 \(days) 天，畅享全部会员权益"
            }
            return "畅享全部会员权益"
        }
        if session.isExpired {
            return "会员已过期，续费后立即恢复权益"
        }
        return "解锁无限查询与全部高级工具"
    }

    // MARK: - Benefits

    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkySectionHeader(title: "会员权益")

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(MembershipBenefit.all) { benefit in
                    HStack(spacing: 10) {
                        Image(systemName: benefit.icon)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Theme.accent)
                            .frame(width: 26, height: 26)
                            .background(Theme.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 7, style: .continuous))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(benefit.title)
                                .font(.system(size: 13, weight: .medium))
                            Text(benefit.subtitle)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(10)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Theme.Radius.standard, style: .continuous))
                }
            }
        }
    }

    // MARK: - Plans

    private var plansSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkySectionHeader(title: "选择套餐")

            ForEach(MembershipPlan.all) { plan in
                planRow(plan)
            }
        }
    }

    private func planRow(_ plan: MembershipPlan) -> some View {
        let isSelected = plan.id == selectedPlanID
        return Button {
            withAnimation(AppAnimation.quick) { selectedPlanID = plan.id }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? Theme.accent : .secondary.opacity(0.4), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle().fill(Theme.accent).frame(width: 12, height: 12)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(plan.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                        if let badge = plan.badge {
                            SkyBadge(text: badge)
                        }
                    }
                    Text(plan.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(skyPriceText(plan.price))
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.accent)
                    if let original = plan.originalPrice {
                        Text(skyPriceText(original))
                            .font(.caption2)
                            .strikethrough()
                            .foregroundStyle(.secondary)
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
    }

    private var footer: some View {
        VStack(spacing: 12) {
            Button {
                guard let plan = MembershipPlan.all.first(where: { $0.id == selectedPlanID }) else { return }
                session.activate(plan)
                toasts.show("开通成功：\(plan.title)")
            } label: {
                Text("立即开通")
            }
            .buttonStyle(SkyPrimaryButtonStyle())

            Text("开通即代表同意《会员服务协议》，虚拟商品开通后不支持退款。")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }

    private var background: some View {
        Color(.systemGroupedBackground).ignoresSafeArea()
    }
}
