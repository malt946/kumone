import Combine
import Foundation

/// 账号与会员状态（当前为本地 mock，后续接入真实服务后替换）。
@MainActor
final class SkySession: ObservableObject {
    static let shared = SkySession()

    enum Keys {
        static let nickname = "sky.account.nickname"
        static let accountID = "sky.account.id"
        static let membershipStart = "sky.membership.start"
        static let membershipExpiry = "sky.membership.expiry"
    }

    @Published var nickname: String
    @Published var accountID: String
    @Published private(set) var membershipStart: Date?
    @Published private(set) var membershipExpiry: Date?

    private let defaults = UserDefaults.standard

    private init() {
        nickname = defaults.string(forKey: Keys.nickname) ?? "旅行者"
        accountID = defaults.string(forKey: Keys.accountID) ?? Self.makeAccountID()
        membershipStart = defaults.object(forKey: Keys.membershipStart) as? Date
        membershipExpiry = defaults.object(forKey: Keys.membershipExpiry) as? Date
    }

    /// 是否为有效会员。
    var isVIP: Bool {
        guard let expiry = membershipExpiry else { return false }
        return expiry > Date()
    }

    /// 会员是否已到期（曾开通过但已过期）。
    var isExpired: Bool {
        guard let expiry = membershipExpiry else { return false }
        return expiry <= Date()
    }

    /// 剩余天数。
    var remainingDays: Int? {
        guard let expiry = membershipExpiry, expiry > Date() else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: expiry).day
    }

    /// 开通会员（mock：立即生效，按套餐天数顺延）。
    func activate(_ plan: MembershipPlan) {
        let now = Date()
        let base = (membershipExpiry.map { max($0, now) }) ?? now
        let start = membershipStart ?? now
        membershipStart = start
        membershipExpiry = Calendar.current.date(byAdding: .day, value: plan.days, to: base)
        defaults.set(start, forKey: Keys.membershipStart)
        defaults.set(membershipExpiry, forKey: Keys.membershipExpiry)
    }

    private static func makeAccountID() -> String {
        let digits = (0..<8).map { _ in String(Int.random(in: 0...9)) }.joined()
        return "SKY-\(digits)"
    }
}
