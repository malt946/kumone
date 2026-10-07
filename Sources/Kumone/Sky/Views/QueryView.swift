import Foundation
import SwiftUI

/// 查询页：输入账号信息，展示身高查询结果与历史记录。
struct QueryView: View {
    @EnvironmentObject private var store: SkyQueryStore
    @EnvironmentObject private var toasts: AppToastCenter

    @State private var nickname = ""
    @State private var accountID = ""
    @State private var isQuerying = false
    @State private var result: SkyQueryResult?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                hero
                inputCard
                if let result {
                    resultCard(result)
                }
                recentSection
                Color.clear.frame(height: SkyAppRoot.tabBarClearance)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(background)
        .navigationTitle("身高查询")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: Theme.Radius.panel, style: .continuous)
                .fill(Theme.accentGradient)

            Image(systemName: "figure.walk.motion")
                .font(.system(size: 120, weight: .bold))
                .foregroundStyle(.white.opacity(0.12))
                .offset(x: 200, y: 20)

            VStack(alignment: .leading, spacing: 8) {
                Text("光遇身高查询")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                Text("输入好友码或昵称，一键获取角色身高与体型")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(20)
        }
        .frame(height: 148)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.panel, style: .continuous))
    }

    // MARK: - Input

    private var inputCard: some View {
        SkyCard {
            VStack(alignment: .leading, spacing: 14) {
                SkySectionHeader(title: "查询信息")

                field(icon: "person.fill", placeholder: "昵称（选填）", text: $nickname)
                field(icon: "number", placeholder: "好友码 / 光遇 ID", text: $accountID)

                Button {
                    Task { await runQuery() }
                } label: {
                    HStack(spacing: 8) {
                        if isQuerying {
                            ProgressView().tint(.white)
                        } else {
                            Image(systemName: "magnifyingglass")
                        }
                        Text(isQuerying ? "查询中…" : "开始查询")
                    }
                }
                .buttonStyle(SkyPrimaryButtonStyle())
                .disabled(isQuerying)
            }
        }
    }

    private func field(icon: String, placeholder: LocalizedStringKey, text: Binding<String>) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .frame(width: 20)
            TextField(placeholder, text: text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit { Task { await runQuery() } }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: Theme.Radius.standard, style: .continuous))
    }

    // MARK: - Result

    private func resultCard(_ result: SkyQueryResult) -> some View {
        SkyCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    SkySectionHeader(title: "查询结果")
                    SkyBadge(text: result.bodyType.displayName, tint: result.bodyType.tint)
                }

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(String(format: "%.2f", result.height))
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.accent)
                    Text("游戏单位")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                heightBar(for: result)

                VStack(alignment: .leading, spacing: 6) {
                    detailRow(label: "昵称", value: result.nickname)
                    detailRow(label: "好友码", value: result.accountID)
                    detailRow(label: "更新时间", value: result.updatedAt.formatted(date: .abbreviated, time: .shortened))
                }
            }
        }
    }

    private func heightBar(for result: SkyQueryResult) -> some View {
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

    // MARK: - Recent

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SkySectionHeader(title: "最近查询")
                if !store.records.isEmpty {
                    Button("清空") {
                        store.clear()
                        toasts.show("已清空历史记录")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
            }

            if store.records.isEmpty {
                SkyCard {
                    Text("暂无查询记录")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 12)
                }
            } else {
                ForEach(store.records) { record in
                    recordRow(record)
                }
            }
        }
    }

    private func recordRow(_ record: SkyQueryResult) -> some View {
        SkyCard(padding: 14) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(record.bodyType.tint.opacity(0.15))
                        .frame(width: 42, height: 42)
                    Image(systemName: "figure.stand")
                        .foregroundStyle(record.bodyType.tint)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(record.nickname)
                        .font(.system(size: 15, weight: .medium))
                    Text(record.accountID)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    Text(String(format: "%.2f", record.height))
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.accent)
                    Text(record.bodyType.displayName)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .contextMenu {
            Button(role: .destructive) {
                store.remove(record)
            } label: {
                Label("删除", systemImage: "trash")
            }
        }
        .onTapGesture {
            result = record
        }
    }

    // MARK: - Actions

    private func runQuery() async {
        isQuerying = true
        defer { isQuerying = false }
        let outcome = await store.query(nickname: nickname, accountID: accountID)
        withAnimation(AppAnimation.smooth) {
            result = outcome
        }
        toasts.show("查询完成：\(outcome.bodyType.displayName)")
    }

    private var background: some View {
        ZStack {
            Color(.systemGroupedBackground)
            RadialGradient(
                colors: [Theme.accent.opacity(0.10), .clear],
                center: .top,
                startRadius: 0,
                endRadius: 420
            )
        }
        .ignoresSafeArea()
    }
}
