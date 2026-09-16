// PremiumManager.swift
// BlockData

import Foundation

@MainActor
public final class PremiumManager {
    public static let shared = PremiumManager()
    private init() {}

    public var isPremium: Bool {
        return TGSubscriptionManager.shared.isPremium
    }

    public func isFinishedPurchased() -> Bool {
        return TGSubscriptionManager.shared.isPremium
    }
}
