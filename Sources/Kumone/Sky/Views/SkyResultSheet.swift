import Foundation
import SwiftUI

/// 身高查询结果弹窗：点「开始查询」或最近记录时以 Sheet 形式展示。
struct SkyResultSheet: View {
    let result: SkyQueryResult

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    heightCard
                    detailCard
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("查询结果")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: Theme.Radius.panel, style: .continuous)
                .fill(result.bodyType.tint.gradient)

            Image(systemName: "figure.stand")
                .font(.system(size: 96, weight: .bold))
                .foregroundStyle(.white.opacity(0.16))
                .offset(x: 220, y: 16)

            VStack(alignment: .leading, spacing: 6) {
                Text(result.bodyType.displayName)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                Text("身高查询结果")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(20)
        }
        .frame(height: 128)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.panel, style: .continuous))
    }

    // MARK: - Height

    private var heightCard: some View {
        SkyCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(String(format: "%.2f", result.height))
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.accent)
                    Text("游戏单位")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                }

                heightBar
            }
        }
    }

    private var heightBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.quaternary.opacity(0.5))
                Capsule()
                    .fill(result.bodyType.tint)
                    .frame(width: max(12, geo.size.width * result.normalized))
            }
        }
        .frame(height: 10)
    }

    // MARK: - Detail

    private var detailCard: some View {
        SkyCard {
            VStack(alignment: .leading, spacing: 10) {
                SkySectionHeader(title: "详细信息")
                detailRow(label: "好友码", value: result.accountID)
                detailRow(label: "体型档位", value: result.bodyType.displayName)
                detailRow(label: "更新时间", value: skyDateTimeText(result.updatedAt))
            }
        }
    }

    private func detailRow(label: LocalizedStringKey, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
        }
    }
}
