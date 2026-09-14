// AppRouter.swift
// BlockData

import SwiftUI
import Combine

public enum AppTab: Int, CaseIterable, Sendable {
    case home    = 0
    case protect = 1
    case search  = 2
    case sms     = 3
    case setting = 4

    public var title: String {
        switch self {
        case .home:    return "Home"
        case .protect: return "AI Scanner"
        case .search:  return "Search"
        case .sms:     return "SMS & AI"
        case .setting: return "Settings"
        }
    }

    public var icon: String {
        switch self {
        case .home:    return "house.fill"
        case .protect: return "viewfinder.circle.fill"
        case .search:  return "magnifyingglass"
        case .sms:     return "bubble.left.and.bubble.right.fill"
        case .setting: return "person.crop.circle"
        }
    }
}

@MainActor
public final class AppRouter: ObservableObject {
    public static let shared = AppRouter()

    @Published public var isFirstLaunch: Bool
    @Published public var selectedTab: AppTab = .home
    @Published public var showRatingRequest: Bool = false
    @Published public var pendingPhoneLookup: String? = nil
    @Published public var isAIConsentAccepted: Bool
    @Published public var showActiveShieldSheet: Bool = false
    @Published public var showBlockList: Bool = false
    @Published public var showTutorial: Bool = false
    @Published public var showCriteria: Bool = false
    @Published public var showGuide: Bool = false
    @Published public var showPolicy: Bool = false
    @Published public var showPaywall: Bool = false
    @Published public var isTabBarHidden: Bool = false
    @Published public var smsTabSelection: Int = 0

    public init() {
        let defaults = sharedDefaults ?? UserDefaults.standard
        isFirstLaunch = !defaults.bool(forKey: UserDefaultKey.isNotFirstOpenApp)
        isAIConsentAccepted = defaults.bool(forKey: UserDefaultKey.isAIConsentAccepted)
    }

    public func acceptAIConsent() {
        let defaults = sharedDefaults ?? UserDefaults.standard
        defaults.set(true, forKey: UserDefaultKey.isAIConsentAccepted)
        defaults.synchronize()
        isAIConsentAccepted = true
    }

    public func completeOnboarding() {
        let defaults = sharedDefaults ?? UserDefaults.standard
        defaults.set(true, forKey: UserDefaultKey.isNotFirstOpenApp)
        defaults.synchronize()
        withAnimation(.easeInOut(duration: 0.4)) {
            isFirstLaunch = false
        }
    }

    public func openTab(_ tab: AppTab) {
        selectedTab = tab
    }

    /// Handle deep links and URL schemes
    public func handle(url: URL) {
        guard url.scheme == "callfilter" else { return }
        let host = url.host ?? url.path.replacingOccurrences(of: "/", with: "")
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryParams = Dictionary(uniqueKeysWithValues: (components?.queryItems ?? []).compactMap { item in
            item.value != nil ? (item.name, item.value!) : nil
        })

        switch host {
        case "search":
            if let phone = queryParams["phone"] {
                pendingPhoneLookup = phone
            }
            selectedTab = .search
        case "home":
            selectedTab = .home
        case "protect":
            selectedTab = .protect
        case "sms":
            if let sub = queryParams["sub"], sub == "ai" {
                smsTabSelection = 1
            } else {
                smsTabSelection = 0
            }
            selectedTab = .sms
        case "setting", "settings":
            selectedTab = .setting
        case "blocklist":
            selectedTab = .protect
            showBlockList = true
        case "tutorial":
            selectedTab = .setting
            showTutorial = true
        case "criteria":
            selectedTab = .protect
            showCriteria = true
        case "guide":
            selectedTab = .setting
            showGuide = true
        case "policy":
            selectedTab = .setting
            showPolicy = true
        case "paywall":
            showPaywall = true
        default:
            break
        }
    }
}
