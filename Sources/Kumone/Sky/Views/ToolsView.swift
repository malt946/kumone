import SwiftUI

/// 工具页：小工具集合入口。
struct ToolsView: View {
    @EnvironmentObject private var toasts: AppToastCenter

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("为你准备了常用的光遇小工具，持续更新中。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(SkyTool.all) { tool in
                        toolCard(tool)
                    }
                }

                Color.clear.frame(height: SkyAppRoot.tabBarClearance)
            }
            .padding(16)
        }
        .background(background)
        .navigationTitle("工具")
    }

    private func toolCard(_ tool: SkyTool) -> some View {
        Button {
            toasts.show("「\(tool.title)」开发中，敬请期待")
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: Theme.Radius.standard, style: .continuous)
                        .fill(tool.tint.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: tool.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(tool.tint)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(tool.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(tool.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Theme.Radius.large, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: Theme.Radius.large, style: .continuous)
                    .strokeBorder(.primary.opacity(0.06), lineWidth: 0.5)
            }
        }
        .buttonStyle(.plain)
    }

    private var background: some View {
        Color(.systemGroupedBackground).ignoresSafeArea()
    }
}
