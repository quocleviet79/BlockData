// PhoneDataService.swift
// BlockData

import Foundation
import Combine

@MainActor
public final class PhoneDataService: ObservableObject {
    public static let shared = PhoneDataService()

    @Published public private(set) var isLoaded: Bool = false
    @Published public private(set) var totalEntries: Int = 0

    /// Dictionary chính: phone → CallerInfo, normalized key (digits only)
    private var phoneDict: [String: CallerInfo] = [:]
    /// Raw array cho browse / listing
    public private(set) var allEntries: [CallerInfo] = []

    public init() {}

    // MARK: - Load

    /// Gọi một lần khi app start
    public func loadDataIfNeeded() {
        guard !isLoaded else { return }
        Task {
            await loadData()
        }
    }

    public func loadData() async {
        var dataUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        if dataUrl == nil {
            dataUrl = Bundle(for: PhoneDataService.self).url(forResource: "data", withExtension: "json")
        }
        if dataUrl == nil {
            if let subBundleUrl = Bundle.main.url(forResource: "BlockData_BlockData", withExtension: "bundle"),
               let subBundle = Bundle(url: subBundleUrl) {
                dataUrl = subBundle.url(forResource: "data", withExtension: "json")
            }
        }

        guard let validUrl = dataUrl else {
            print("⚠️ data.json not found in Bundle.main, Bundle.module, or sub-bundles")
            return
        }

        do {
            let data = try Data(contentsOf: validUrl)
            let response = try JSONDecoder().decode(PhoneDataResponse.self, from: data)
            let entries = response.data

            // Build Dictionary with normalized keys and variations
            var dict: [String: CallerInfo] = [:]
            dict.reserveCapacity(entries.count * 3)
            for entry in entries {
                let key = normalizePhone(entry.phone)
                guard !key.isEmpty else { continue }
                dict[key] = entry

                // Variations for Vietnam and US numbers
                if key.hasPrefix("84") && key.count == 11 {
                    let national = String(key.dropFirst(2))
                    dict[national] = entry
                    dict["0" + national] = entry
                } else if key.hasPrefix("0") && (key.count == 10 || key.count == 11) {
                    let national = String(key.dropFirst(1))
                    dict[national] = entry
                    dict["84" + national] = entry
                } else if key.count == 9 {
                    dict["0" + key] = entry
                    dict["84" + key] = entry
                } else if key.count == 10 && !key.hasPrefix("0") {
                    dict["1" + key] = entry
                }
            }

            self.allEntries = entries
            self.phoneDict = dict
            self.totalEntries = entries.count
            self.isLoaded = true
            print("✅ PhoneDataService loaded \(entries.count) entries")

            // Pre-process, normalize to clean E.164 numerical format, deduplicate, and sort for CallKit
            var callKitMap = [Int64: String]()
            callKitMap.reserveCapacity(entries.count)
            for entry in entries {
                if let num = toCallKitNumber(entry.phone) {
                    let label = "\(entry.callerID) - \(entry.callerType)"
                    callKitMap[num] = String(label.prefix(60)).trimmingCharacters(in: .whitespaces)
                }
            }

            let sortedCallKitEntries = callKitMap
                .map { CallKitIdentificationEntry(phone: $0.key, label: $0.value) }
                .sorted { $0.phone < $1.phone }

            print("✅ Pre-sorted \(sortedCallKitEntries.count) clean E.164 entries for CallKit")

            // Write pre-sorted entries to App Group for CallKit extension
            let suites = [appGroup, "group.com.nvp.bc", fallbackAppGroup]
            if let preSortedData = try? JSONEncoder().encode(sortedCallKitEntries) {
                for suite in suites {
                    if let defaults = UserDefaults(suiteName: suite) {
                        defaults.set(preSortedData, forKey: "callkit_entries_v1")
                        defaults.synchronize()
                        print("✅ Saved \(sortedCallKitEntries.count) pre-sorted entries to App Group (\(suite))")
                    }
                    if let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: suite) {
                        let fileURL = container.appendingPathComponent("callkit_entries.json")
                        try? preSortedData.write(to: fileURL)
                    }
                }
            }

            // Also save raw entries for backward compatibility
            if let encoded = try? JSONEncoder().encode(entries) {
                for suite in suites {
                    if let defaults = UserDefaults(suiteName: suite) {
                        defaults.set(encoded, forKey: UserDefaultKey.phoneIdentifierKey)
                        defaults.synchronize()
                    }
                }
            }

            // Trigger extension reload so CallKit refreshes its database immediately
            BlockListService.shared.reloadCallDirectoryExtension()
        } catch {
            print("❌ PhoneDataService load error: \(error)")
        }
    }

    // MARK: - Lookup

    /// Tìm kiếm chính xác theo số điện thoại → O(1)
    public func lookup(phone: String) -> CallerInfo? {
        let key = normalizePhone(phone)
        guard !key.isEmpty else { return nil }
        if let exact = phoneDict[key] {
            return exact
        }
        if key.hasPrefix("84") && key.count == 11 {
            let national = String(key.dropFirst(2))
            return phoneDict["0" + national] ?? phoneDict[national]
        }
        if key.hasPrefix("0") && (key.count == 10 || key.count == 11) {
            let national = String(key.dropFirst(1))
            return phoneDict["84" + national] ?? phoneDict[national]
        }
        if key.count == 9 {
            return phoneDict["0" + key] ?? phoneDict["84" + key]
        }
        if key.count == 10 {
            return phoneDict["1" + key]
        }
        if key.hasPrefix("1") && key.count == 11 {
            return phoneDict[String(key.dropFirst(1))]
        }
        return nil
    }

    /// Tìm kiếm theo prefix hoặc tên
    public func search(query: String, limit: Int = 50) -> [CallerInfo] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()

        return allEntries
            .filter { entry in
                entry.phone.lowercased().contains(q) ||
                entry.callerID.lowercased().contains(q) ||
                entry.callerType.lowercased().contains(q)
            }
            .prefix(limit)
            .map { $0 }
    }

    // MARK: - Phone Normalization

    /// Loại bỏ tất cả ký tự không phải digit
    public func normalizePhone(_ phone: String) -> String {
        return phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    /// Convert sang E.164 numeric cho CallKit (CXCallDirectoryPhoneNumber)
    public func toCallKitNumber(_ phone: String) -> Int64? {
        let digits = normalizePhone(phone)
        guard !digits.isEmpty else { return nil }

        if digits.hasPrefix("84") && digits.count == 11 {
            return Int64(digits)
        } else if digits.hasPrefix("0") && (digits.count == 10 || digits.count == 11) {
            return Int64("84" + digits.dropFirst(1))
        } else if digits.count == 9 {
            return Int64("84" + digits)
        } else if digits.count == 10 {
            return Int64("1" + digits)
        } else if digits.count > 10 {
            return Int64(digits)
        }
        return nil
    }

    /// Lấy subset các số có callerID cho CallKit identification
    public func getIdentificationEntries(limit: Int = 5000) -> [(phone: Int64, label: String)] {
        return allEntries
            .compactMap { entry -> (phone: Int64, label: String)? in
                guard let num = toCallKitNumber(entry.phone) else { return nil }
                return (phone: num, label: entry.callerID)
            }
            .sorted { $0.phone < $1.phone }
            .prefix(limit)
            .map { $0 }
    }
}
