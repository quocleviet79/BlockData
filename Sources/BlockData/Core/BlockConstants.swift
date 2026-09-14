// BlockConstants.swift
// BlockData

import Foundation

// MARK: - App Group & Extension Identifiers

public let appGroup = "group.com.an.blockcall"
public let legacyAppGroup = "group.com.an.blockcall"
public let callExtensionID = "com.an.blockcall.CallDirectoryExt"
public let messageExtensionID = "com.an.blockcall.MessageFilterExt"
public let shareExtensionID = "com.an.blockcall.ShareExtension"

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
    return UserDefaults(suiteName: appGroup) ?? UserDefaults(suiteName: legacyAppGroup) ?? UserDefaults.standard
}
