// BlockConstants.swift
// BlockData

import Foundation

// MARK: - App Group & Extension Identifiers

public let appGroup = "group.com.an.blockcall"
public let fallbackAppGroup = "group.com.an.blockcall"
public let legacyAppGroup = "group.com.an.blockcall"

/// Dynamic CallDirectory extension identifier matching the app's bundle ID.
public var callExtensionID: String {
    guard let mainID = Bundle.main.bundleIdentifier, !mainID.isEmpty else {
        return "com.tranthien.test.CallDirectoryExt"
    }
    if mainID.hasSuffix(".CallDirectoryExt") {
        return mainID
    }
    let baseID = mainID
        .replacingOccurrences(of: ".MessageFilterExt", with: "")
        .replacingOccurrences(of: ".ShareExtension", with: "")
    return "\(baseID).CallDirectoryExt"
}

public var messageExtensionID: String {
    guard let mainID = Bundle.main.bundleIdentifier, !mainID.isEmpty else {
        return "com.tranthien.test.MessageFilterExt"
    }
    if mainID.hasSuffix(".MessageFilterExt") {
        return mainID
    }
    let baseID = mainID
        .replacingOccurrences(of: ".CallDirectoryExt", with: "")
        .replacingOccurrences(of: ".ShareExtension", with: "")
    return "\(baseID).MessageFilterExt"
}

public var shareExtensionID: String {
    guard let mainID = Bundle.main.bundleIdentifier, !mainID.isEmpty else {
        return "com.tranthien.test.ShareExtension"
    }
    if mainID.hasSuffix(".ShareExtension") {
        return mainID
    }
    let baseID = mainID
        .replacingOccurrences(of: ".CallDirectoryExt", with: "")
        .replacingOccurrences(of: ".MessageFilterExt", with: "")
    return "\(baseID).ShareExtension"
}

// MARK: - Shared File Names

public let blockListFileName = "BlockList.json"
public let phoneIdentifierFileName = "PhoneIdentifier.json"

// MARK: - App URLs

public struct AppURLs {
    public static let webSite = "https://auto-click.space/"
    public static let term = "https://auto-click.space/terms"
    public static let privacy = "https://auto-click.space/privacy"
    public static let contact = "https://auto-click.space/support"
}

// MARK: - UserDefaults Keys

public struct UserDefaultKey {
    public static let isNotFirstOpenApp = "isNotFirstOpenApp"
    public static let countSearch = "countSearch"
    public static let searchFromContact = "SearchFromContact"
    public static let phoneTutorialSeen = "PHONE-TUTORIAL"
    public static let appTutorialSeen = "APP-TUTORIAL"
    public static let isAIConsentAccepted = "isAIConsentAccepted"
    public static let blockedNumbersKey = "blocked_numbers_v1"
    public static let phoneIdentifierKey = "phone_identifier_v1"
}

// MARK: - Shared UserDefaults

public var sharedDefaults: UserDefaults? {
    return UserDefaults(suiteName: appGroup) ?? UserDefaults(suiteName: fallbackAppGroup) ?? UserDefaults.standard
}

#if canImport(CallKit)
import CallKit

public func checkCallDirectoryStatus(completion: @escaping (CXCallDirectoryManager.EnabledStatus) -> Void) {
    let primary = callExtensionID
    CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: primary) { status, _ in
        if status == .enabled {
            completion(.enabled)
        } else {
            let fallback = "com.tranthien.test.CallDirectoryExt"
            if fallback != primary {
                CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: fallback) { fbStatus, _ in
                    completion(fbStatus == .enabled ? .enabled : status)
                }
            } else {
                completion(status)
            }
        }
    }
}
#endif
