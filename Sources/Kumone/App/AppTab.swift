import SwiftUI

/// 应用的四个主 Tab。
enum AppTab: String, CaseIterable, Identifiable, Hashable {
    case query
    case tools
    case store
    case profile

    var id: String { rawValue }

    var title: LocalizedStringKey {
        switch self {
        case .query: return "查询"
        case .tools: return "工具"
        case .store: return "商城"
        case .profile: return "我的"
        }
    }

    var icon: String {
        switch self {
        case .query: return "magnifyingglass.circle"
        case .tools: return "wrench.and.screwdriver"
        case .store: return "bag"
        case .profile: return "person.crop.circle"
        }
    }
}
