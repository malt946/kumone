import Foundation
import SwiftUI

// MARK: - 身高查询

/// 一次身高查询的结果。
struct SkyQueryResult: Identifiable, Hashable {
    let id: UUID
    /// 账号唯一标识（光遇 ID / 好友码）。
    var accountID: String
    /// 身高数值，单位为「游戏单位」。
    var height: Double
    /// 体型档位。
    var bodyType: SkyBodyType
    /// 数据更新时间。
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        accountID: String,
        height: Double,
        bodyType: SkyBodyType,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.accountID = accountID
        self.height = height
        self.bodyType = bodyType
        self.updatedAt = updatedAt
    }

    /// 由身高数值自动判定体型档位。
    init(
        id: UUID = UUID(),
        accountID: String,
        height: Double,
        updatedAt: Date = Date()
    ) {
        self.init(
            id: id,
            accountID: accountID,
            height: height,
            bodyType: SkyBodyType.classify(height),
            updatedAt: updatedAt
        )
    }

    /// 归一化后的身高百分比（0...1），用于进度条展示。
    var normalized: Double {
        let lower = 0.0
        let upper = 2.0
        return min(max((height - lower) / (upper - lower), 0), 1)
    }
}

/// 光遇身高体型档位。
enum SkyBodyType: String, CaseIterable, Identifiable, Hashable {
    case petite = "petite"
    case standard = "standard"
    case tall = "tall"
    case giant = "giant"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .petite: return String(localized: "娇小")
        case .standard: return String(localized: "标准")
        case .tall: return String(localized: "修长")
        case .giant: return String(localized: "高挑")
        }
    }

    var tint: Color {
        switch self {
        case .petite: return Color(red: 0.42, green: 0.74, blue: 0.92)
        case .standard: return Color(red: 0.36, green: 0.78, blue: 0.62)
        case .tall: return Color(red: 0.95, green: 0.68, blue: 0.32)
        case .giant: return Color(red: 0.90, green: 0.42, blue: 0.52)
        }
    }

    static func classify(_ height: Double) -> SkyBodyType {
        switch height {
        case ..<0.5: return .petite
        case ..<1.1: return .standard
        case ..<1.6: return .tall
        default: return .giant
        }
    }
}

// MARK: - 工具

/// 工具页中的一个功能入口。
struct SkyTool: Identifiable, Hashable {
    let id: String
    var title: String
    var subtitle: String
    var icon: String
    var tint: Color

    static let all: [SkyTool] = [
        SkyTool(
            id: "converter",
            title: String(localized: "身高换算器"),
            subtitle: String(localized: "游戏单位与真实身高互转"),
            icon: "ruler",
            tint: Color(red: 0.42, green: 0.66, blue: 0.95)
        ),
        SkyTool(
            id: "chart",
            title: String(localized: "体型对照表"),
            subtitle: String(localized: "查看各档位身高分布"),
            icon: "chart.bar.xaxis",
            tint: Color(red: 0.36, green: 0.78, blue: 0.62)
        ),
        SkyTool(
            id: "candle",
            title: String(localized: "蜡烛计算器"),
            subtitle: String(localized: "估算每日蜡烛收益"),
            icon: "flame.fill",
            tint: Color(red: 0.96, green: 0.60, blue: 0.24)
        ),
        SkyTool(
            id: "season",
            title: String(localized: "复刻进度"),
            subtitle: String(localized: "追踪季节先祖进度"),
            icon: "sparkles",
            tint: Color(red: 0.72, green: 0.50, blue: 0.95)
        ),
        SkyTool(
            id: "ancestor",
            title: String(localized: "先祖图鉴"),
            subtitle: String(localized: "全先祖位置与兑换"),
            icon: "books.vertical.fill",
            tint: Color(red: 0.90, green: 0.48, blue: 0.48)
        ),
        SkyTool(
            id: "friend",
            title: String(localized: "好友码解析"),
            subtitle: String(localized: "快速解析好友邀请码"),
            icon: "person.2.fill",
            tint: Color(red: 0.30, green: 0.72, blue: 0.86)
        ),
    ]
}

// MARK: - 会员 / 商城

/// 会员套餐。
struct MembershipPlan: Identifiable, Hashable {
    let id: String
    var title: String
    var subtitle: String
    var price: Double
    var originalPrice: Double?
    var badge: String?
    /// 有效天数，用于计算到期时间。
    var days: Int

    static let all: [MembershipPlan] = [
        MembershipPlan(
            id: "month",
            title: String(localized: "月卡会员"),
            subtitle: String(localized: "开通立享 30 天会员权益"),
            price: 6,
            originalPrice: 12,
            badge: nil,
            days: 30
        ),
        MembershipPlan(
            id: "quarter",
            title: String(localized: "季卡会员"),
            subtitle: String(localized: "开通立享 90 天会员权益"),
            price: 15,
            originalPrice: 36,
            badge: String(localized: "推荐"),
            days: 90
        ),
        MembershipPlan(
            id: "year",
            title: String(localized: "年卡会员"),
            subtitle: String(localized: "开通立享 365 天会员权益"),
            price: 48,
            originalPrice: 144,
            badge: String(localized: "超值"),
            days: 365
        ),
        MembershipPlan(
            id: "forever",
            title: String(localized: "永久会员"),
            subtitle: String(localized: "一次开通，永久有效"),
            price: 128,
            originalPrice: 328,
            badge: String(localized: "限时"),
            days: 36500
        ),
    ]
}

/// 商城权益条目。
struct MembershipBenefit: Identifiable, Hashable {
    let id: String
    var icon: String
    var title: String
    var subtitle: String

    static let all: [MembershipBenefit] = [
        MembershipBenefit(
            id: "unlimited",
            icon: "infinity",
            title: String(localized: "无限次查询"),
            subtitle: String(localized: "不限查询次数")
        ),
        MembershipBenefit(
            id: "history",
            icon: "clock.arrow.circlepath",
            title: String(localized: "历史记录云同步"),
            subtitle: String(localized: "跨设备保存查询结果")
        ),
        MembershipBenefit(
            id: "tools",
            icon: "wrench.and.screwdriver.fill",
            title: String(localized: "全部小工具"),
            subtitle: String(localized: "解锁所有高级工具")
        ),
        MembershipBenefit(
            id: "priority",
            icon: "bolt.fill",
            title: String(localized: "高速通道"),
            subtitle: String(localized: "查询优先处理")
        ),
        MembershipBenefit(
            id: "support",
            icon: "headphones",
            title: String(localized: "专属客服"),
            subtitle: String(localized: "优先响应处理问题")
        ),
        MembershipBenefit(
            id: "noads",
            icon: "hand.raised.fill",
            title: String(localized: "全程无广告"),
            subtitle: String(localized: "纯净使用体验")
        ),
    ]
}
