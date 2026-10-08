import SwiftUI

/// 购买记录：按时间倒序展示会员订单。
struct SkyOrdersView: View {
    @EnvironmentObject private var orderStore: SkyOrderStore

    var body: some View {
        Group {
            if orderStore.orders.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(orderStore.orders) { order in
                            orderCard(order)
                        }
                        Color.clear.frame(height: SkyAppRoot.tabBarClearance)
                    }
                    .padding(16)
                }
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("购买记录")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Empty

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "receipt")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text("暂无购买记录")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Order card

    private func orderCard(_ order: SkyOrder) -> some View {
        SkyCard(padding: 14) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(order.planTitle)
                        .font(.system(size: 15, weight: .semibold))
                    Spacer()
                    Text(skyPriceText(order.amount))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.accent)
                }

                HStack(spacing: 8) {
                    Image(order.method.iconAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                    Text(order.method.title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    SkyBadge(text: order.status.displayName, tint: order.status.tint)
                }

                Divider()

                VStack(alignment: .leading, spacing: 6) {
                    orderRow(label: "订单号", value: order.orderNumber)
                    orderRow(label: "下单时间", value: skyDateTimeSecondsText(order.createdAt))
                }
            }
        }
    }

    private func orderRow(label: LocalizedStringKey, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption.weight(.medium))
                .multilineTextAlignment(.trailing)
                .textSelection(.enabled)
        }
    }
}
