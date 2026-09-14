// BlockListService.swift
// BlockData

import Foundation
import Combine
import CallKit
import SwiftUI

@MainActor
public final class BlockListService: ObservableObject {
    public static let shared = BlockListService()

    @Published public private(set) var blockedNumbers: [BlockedNumber] = []
    @Published public private(set) var searchHistory: [SearchHistoryItem] = []

    private let blockedKey = UserDefaultKey.blockedNumbersKey
    private let historyKey = "search_history_v1"
    private let maxHistoryCount = 50

    public init() {
        loadFromStorage()
    }

    // MARK: - Load / Save

    public func loadFromStorage() {
        if let data = sharedDefaults?.data(forKey: blockedKey),
           let items = try? JSONDecoder().decode([BlockedNumber].self, from: data) {
            blockedNumbers = items
        }
        if let data = sharedDefaults?.data(forKey: historyKey),
           let items = try? JSONDecoder().decode([SearchHistoryItem].self, from: data) {
            searchHistory = items
        }
    }

    private func saveBlockedNumbers() {
        guard let data = try? JSONEncoder().encode(blockedNumbers) else { return }
        sharedDefaults?.set(data, forKey: blockedKey)
        sharedDefaults?.synchronize()
    }

    private func saveSearchHistory() {
        guard let data = try? JSONEncoder().encode(searchHistory) else { return }
        sharedDefaults?.set(data, forKey: historyKey)
        sharedDefaults?.synchronize()
    }

    // MARK: - Block List CRUD

    public func addBlock(_ number: BlockedNumber) {
        guard !isBlocked(number.phone) else { return }
        blockedNumbers.insert(number, at: 0)
        saveBlockedNumbers()
        reloadCallDirectoryExtension()
    }

    public func addBlock(from callerInfo: CallerInfo) {
        addBlock(BlockedNumber(from: callerInfo))
    }

    public func removeBlock(phone: String) {
        blockedNumbers.removeAll { $0.phone == phone }
        saveBlockedNumbers()
        reloadCallDirectoryExtension()
    }

    public func removeBlocks(at offsets: IndexSet) {
        blockedNumbers.remove(atOffsets: offsets)
        saveBlockedNumbers()
        reloadCallDirectoryExtension()
    }

    public func isBlocked(_ phone: String) -> Bool {
        let normalized = PhoneDataService.shared.normalizePhone(phone)
        return blockedNumbers.contains { PhoneDataService.shared.normalizePhone($0.phone) == normalized }
    }

    // MARK: - Search History

    public func addSearchHistory(_ item: SearchHistoryItem) {
        searchHistory.removeAll { $0.phone == item.phone }
        searchHistory.insert(item, at: 0)
        if searchHistory.count > maxHistoryCount {
            searchHistory = Array(searchHistory.prefix(maxHistoryCount))
        }
        saveSearchHistory()
    }

    public func addSearchHistory(from callerInfo: CallerInfo) {
        addSearchHistory(SearchHistoryItem(from: callerInfo))
    }

    public func clearSearchHistory() {
        searchHistory.removeAll()
        saveSearchHistory()
    }

    public func removeSearchHistory(phone: String) {
        searchHistory.removeAll { $0.phone == phone }
        saveSearchHistory()
    }

    // MARK: - CallKit Extension Reload

    public func reloadCallDirectoryExtension() {
        #if os(iOS)
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: callExtensionID) { error in
            if let error = error {
                print("⚠️ CallDirectory reload error: \(error.localizedDescription)")
            } else {
                print("✅ CallDirectory reloaded")
            }
        }
        #endif
    }

    // MARK: - Export for CallKit

    public var blockedPhoneNumbers: [Int64] {
        return blockedNumbers
            .compactMap { PhoneDataService.shared.toCallKitNumber($0.phone) }
            .sorted()
    }
}
