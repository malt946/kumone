import Combine
import Foundation
import SwiftUI

/// 轻量级全局提示，底部/顶部浮层展示，3 秒后自动消失。
struct AppToast: Identifiable, Equatable {
    let id = UUID()
    let message: String
}

@MainActor
final class AppToastCenter: ObservableObject {
    static let shared = AppToastCenter()

    @Published var current: AppToast?
    private var dismissTask: Task<Void, Never>?

    private init() {}

    func show(_ message: String) {
        current = AppToast(message: message)
        dismissTask?.cancel()
        dismissTask = Task {
            try? await Task.sleep(for: .seconds(3))
            guard !Task.isCancelled else { return }
            current = nil
        }
    }
}

/// 浮层提示视图。
struct AppToastView: View {
    let toast: AppToast

    var body: some View {
        Text(toast.message)
            .font(.system(size: 13, weight: .medium))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .compatGlass(in: Capsule())
            .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
    }
}
