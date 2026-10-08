import SwiftUI

/// 会员详情页：会员状态摘要 + 续费/购买记录入口。
struct SkyMembershipDetailView: View {
    @EnvironmentObject private var session: SkySession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                summaryCard
                entriesSection
                Color.clear.frame(height: SkyAppRoot.tabBarClearance)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("会员详情")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Summary

    private var summaryCard: some View {
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
                    infoRow(label: "到期时间", value: skyDateTimeSecondsText(session.membershipExpiry))
                    if let days = session.remainingDays {
                        infoRow(label: "剩余天数", value: "\(days) 天")
                    }
                } else if session.isExpired {
                    Text("你的会员已于 \(skyDateTimeSecondsText(session.membershipExpiry)) 到期。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("尚未开通会员，开通后可解锁全部功能与高级工具。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
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

    // MARK: - Entries

    private var entriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SkyCard(padding: 0) {
                VStack(spacing: 0) {
                    renewEntry
                    Divider().padding(.leading, 60)
                    ordersEntry
                }
            }
        }
    }

    private var renewEntry: some View {
        NavigationLink {
            StoreView()
        } label: {
            HStack(spacing: 14) {
                entryIcon("cart.fill")
                VStack(alignment: .leading, spacing: 3) {
                    Text(session.isVIP ? "续费会员" : "开通会员")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text("选择套餐并完成支付")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                chevron
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var ordersEntry: some View {
        NavigationLink {
            SkyOrdersView()
        } label: {
            HStack(spacing: 14) {
                entryIcon("receipt")
                VStack(alignment: .leading, spacing: 3) {
                    Text("购买记录")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text("查看历史订单")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                chevron
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func entryIcon(_ name: String) -> some View {
        Image(systemName: name)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 38, height: 38)
            .background(Theme.accentGradient, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.tertiary)
    }
}
