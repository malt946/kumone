import SwiftUI

/// 工具页：小工具集合入口。
struct ToolsView: View {
    @EnvironmentObject private var toasts: AppToastCenter

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header

                SkyCard(padding: 0) {
                    VStack(spacing: 0) {
                        ForEach(Array(SkyTool.all.enumerated()), id: \.element.id) { offset, tool in
                            toolRow(tool)
                            if offset != SkyTool.all.count - 1 {
                                Divider().padding(.leading, 78)
                            }
                        }
                    }
                }

                Color.clear.frame(height: SkyAppRoot.tabBarClearance)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(background)
        .navigationTitle("工具")
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("实用工具")
                .font(.system(size: 22, weight: .bold))
            Text("为旅人准备的常用小工具，持续更新中")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 4)
    }

    // MARK: - Row

    private func toolRow(_ tool: SkyTool) -> some View {
        Button {
            toasts.show("「\(tool.title)」开发中，敬请期待")
        } label: {
            HStack(spacing: 14) {
                iconBadge(tool)

                VStack(alignment: .leading, spacing: 3) {
                    Text(tool.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(tool.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func iconBadge(_ tool: SkyTool) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [tool.tint, tool.tint.opacity(0.72)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 46, height: 46)
                .shadow(color: tool.tint.opacity(0.30), radius: 5, y: 2)

            Image(systemName: tool.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
        }
    }

    private var background: some View {
        Color(.systemGroupedBackground).ignoresSafeArea()
    }
}
