import Combine
import Foundation

/// 购买订单存储与查询（本地持久化，后续接入真实服务后替换）。
@MainActor
final class SkyOrderStore: ObservableObject {
    static let shared = SkyOrderStore()

    @Published private(set) var orders: [SkyOrder]

    private static let maxOrders = 100
    private static let storageKey = "sky.orders.storage"

    private let defaults = UserDefaults.standard

    private init() {
        orders = Self.load(from: defaults)
    }

    /// 记录一笔已支付订单。
    @discardableResult
    func add(plan: MembershipPlan, method: PaymentMethod) -> SkyOrder {
        let order = SkyOrder(
            orderNumber: Self.makeOrderNumber(),
            planTitle: plan.title,
            amount: plan.price,
            method: method
        )
        orders.insert(order, at: 0)
        if orders.count > Self.maxOrders {
            orders.removeLast(orders.count - Self.maxOrders)
        }
        save()
        return order
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(orders) else { return }
        defaults.set(data, forKey: Self.storageKey)
    }

    private static func load(from defaults: UserDefaults) -> [SkyOrder] {
        guard let data = defaults.data(forKey: storageKey),
              let orders = try? JSONDecoder().decode([SkyOrder].self, from: data) else {
            return []
        }
        return orders
    }

    private static func makeOrderNumber() -> String {
        let date = skyOrderNumberDateFormatter.string(from: Date())
        let digits = (0..<6).map { _ in String(Int.random(in: 0...9)) }.joined()
        return "SKY\(date)\(digits)"
    }
}

private let skyOrderNumberDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyyMMddHHmmss"
    return formatter
}()
