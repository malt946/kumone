import Combine
import SwiftUI

/// 外观偏好。
enum SkyAppearance: String, CaseIterable, Identifiable {
    case auto, light, dark

    var id: String { rawValue }

    var displayName: LocalizedStringKey {
        switch self {
        case .auto: return "跟随系统"
        case .light: return "浅色"
        case .dark: return "深色"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .auto: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

/// 应用级设置，持久化在 UserDefaults。
@MainActor
final class AppSettings: ObservableObject {
    static let shared = AppSettings()

    enum Keys {
        static let appearance = "sky.settings.appearance"
        static let acceptedAgreement = "sky.settings.acceptedAgreement"
        static let agreementVersion = "sky.settings.agreementVersion"
    }

    /// 当协议文案更新时递增，用户需要重新同意。
    static let currentAgreementVersion = 1

    @Published var appearance: SkyAppearance {
        didSet { UserDefaults.standard.set(appearance.rawValue, forKey: Keys.appearance) }
    }

    /// 是否已同意用户协议与隐私政策。
    @Published var hasAcceptedAgreement: Bool {
        didSet { UserDefaults.standard.set(hasAcceptedAgreement, forKey: Keys.acceptedAgreement) }
    }

    private init() {
        let defaults = UserDefaults.standard
        let raw = defaults.string(forKey: Keys.appearance) ?? SkyAppearance.auto.rawValue
        appearance = SkyAppearance(rawValue: raw) ?? .auto

        let acceptedVersion = defaults.integer(forKey: Keys.agreementVersion)
        hasAcceptedAgreement = defaults.bool(forKey: Keys.acceptedAgreement)
            && acceptedVersion == Self.currentAgreementVersion
    }

    func acceptAgreement() {
        UserDefaults.standard.set(Self.currentAgreementVersion, forKey: Keys.agreementVersion)
        hasAcceptedAgreement = true
    }
}
