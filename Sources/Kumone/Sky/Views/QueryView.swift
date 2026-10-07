import Foundation
import SwiftUI

/// 查询页：输入账号信息，展示身高查询结果与历史记录。
struct QueryView: View {
    @EnvironmentObject private var store: SkyQueryStore
    @EnvironmentObject private var toasts: AppToastCenter

    @State private var accountID = ""
    @State private var isQuerying = false
    @State private var sheetResult: SkyQueryResult?
    @State private var errorMessage: String?
    @FocusState private var isFieldFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                hero
                inputCard
                recentSection
                Color.clear.frame(height: SkyAppRoot.tabBarClearance)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(background)
        .navigationTitle("身高查询")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("完成") { isFieldFocused = false }
            }
        }
        .sheet(item: $sheetResult) { result in
            SkyResultSheet(result: result)
        }
        .alert("查询失败", isPresented: errorBinding) {
            Button("重试") { Task { await runQuery() } }
            Button("取消", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )
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
                Text("输入好友码或光遇 ID，一键获取角色身高与体型")
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

                field(icon: "number", placeholder: "好友码 / 光遇 ID", text: $accountID)

                Button {
                    isFieldFocused = false
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
                .focused($isFieldFocused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit {
                    isFieldFocused = false
                    Task { await runQuery() }
                }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: Theme.Radius.standard, style: .continuous))
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
                    SkyStateView.empty(
                        title: "暂无查询记录",
                        message: "填写好友码或光遇 ID 后点击「开始查询」，结果会保存在这里。",
                        icon: "clock.arrow.circlepath"
                    )
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
                    Text(record.accountID)
                        .font(.system(size: 15, weight: .medium))
                    Text(record.updatedAt.formatted(date: .abbreviated, time: .shortened))
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
            sheetResult = record
        }
    }

    // MARK: - Actions

    private func runQuery() async {
        isQuerying = true
        errorMessage = nil
        defer { isQuerying = false }
        do {
            let outcome = try await store.query(accountID: accountID)
            sheetResult = outcome
        } catch {
            errorMessage = error.localizedDescription
        }
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
