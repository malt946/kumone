import Combine
import Foundation

/// 查询过程中可能抛出的错误。
enum SkyQueryError: LocalizedError {
    /// 未填写好友码 / 光遇 ID。
    case missingAccountID

    var errorDescription: String? {
        String(localized: "请输入好友码或光遇 ID 后再查询。")
    }
}

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
    /// - Throws: `SkyQueryError`。
    @discardableResult
    func query(accountID: String) async throws -> SkyQueryResult {
        // 模拟网络延迟。
        try? await Task.sleep(for: .milliseconds(600))

        let id = accountID.trimmingCharacters(in: .whitespaces)
        guard !id.isEmpty else {
            throw SkyQueryError.missingAccountID
        }

        let height = Double.random(in: 0.05...1.95)
        let result = SkyQueryResult(
            accountID: id,
            height: (height * 100).rounded() / 100
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
                accountID: "SKY-88213490",
                height: 1.42,
                updatedAt: Date().addingTimeInterval(-3600)
            ),
            SkyQueryResult(
                accountID: "SKY-10293847",
                height: 0.38,
                updatedAt: Date().addingTimeInterval(-86400)
            ),
        ]
    }
}
