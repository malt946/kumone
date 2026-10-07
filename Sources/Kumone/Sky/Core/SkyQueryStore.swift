import Combine
import Foundation

/// 身高查询服务与历史记录（当前为本地 mock，后续替换为真实接口）。
@MainActor
final class SkyQueryStore: ObservableObject {
    static let shared = SkyQueryStore()

    @Published private(set) var records: [SkyQueryResult]

    private static let maxRecords = 20

    private init() {
        records = Self.seedRecords()
    }

    /// 执行一次查询。真实实现应请求后端；此处返回 mock 结果。
    @discardableResult
    func query(nickname: String, accountID: String? = nil) async -> SkyQueryResult {
        // 模拟网络延迟。
        try? await Task.sleep(for: .milliseconds(600))

        let id = accountID?.trimmingCharacters(in: .whitespaces)
        let resolvedID = (id?.isEmpty == false ? id! : "SKY-\(Int.random(in: 10000000...99999999))")
        let height = Double.random(in: 0.05...1.95)
        let result = SkyQueryResult(
            nickname: nickname.trimmingCharacters(in: .whitespaces).isEmpty ? "旅行者" : nickname,
            accountID: resolvedID,
            height: (height * 100).rounded() / 100,
            bodyType: SkyBodyType.classify(height)
        )

        records.insert(result, at: 0)
        if records.count > Self.maxRecords {
            records.removeLast(records.count - Self.maxRecords)
        }
        return result
    }

    func remove(_ record: SkyQueryResult) {
        records.removeAll { $0.id == record.id }
    }

    func clear() {
        records.removeAll()
    }

    private static func seedRecords() -> [SkyQueryResult] {
        [
            SkyQueryResult(
                nickname: "光之子",
                accountID: "SKY-88213490",
                height: 1.42,
                bodyType: .tall,
                updatedAt: Date().addingTimeInterval(-3600)
            ),
            SkyQueryResult(
                nickname: "小矮人",
                accountID: "SKY-10293847",
                height: 0.38,
                bodyType: .petite,
                updatedAt: Date().addingTimeInterval(-86400)
            ),
        ]
    }
}
