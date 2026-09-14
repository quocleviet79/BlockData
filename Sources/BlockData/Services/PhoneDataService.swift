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
        let url = Bundle.module.url(forResource: "data", withExtension: "json")
            ?? Bundle.main.url(forResource: "data", withExtension: "json")

        guard let dataUrl = url else {
            print("⚠️ data.json not found in Bundle.module or Bundle.main")
            return
        }

        do {
            let data = try Data(contentsOf: dataUrl)
            let response = try JSONDecoder().decode(PhoneDataResponse.self, from: data)
            let entries = response.data

            // Build Dictionary với normalized keys
            var dict: [String: CallerInfo] = [:]
            dict.reserveCapacity(entries.count)
            for entry in entries {
                let key = normalizePhone(entry.phone)
                dict[key] = entry
            }

            self.allEntries = entries
            self.phoneDict = dict
            self.totalEntries = entries.count
            self.isLoaded = true
            print("✅ PhoneDataService loaded \(entries.count) entries")

            // Write identifiers to App Group for CallKit extension
            if let encoded = try? JSONEncoder().encode(entries),
               let defaults = UserDefaults(suiteName: appGroup) ?? UserDefaults(suiteName: legacyAppGroup) {
                defaults.set(encoded, forKey: UserDefaultKey.phoneIdentifierKey)
                defaults.synchronize()
                print("✅ Saved \(entries.count) entries to App Group for CallKit identification")
            }
        } catch {
            print("❌ PhoneDataService load error: \(error)")
        }
    }

    // MARK: - Lookup

    /// Tìm kiếm chính xác theo số điện thoại → O(1)
    public func lookup(phone: String) -> CallerInfo? {
        let key = normalizePhone(phone)
        return phoneDict[key]
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

        let withCountry: String
        if digits.count == 10 {
            withCountry = "1" + digits
        } else {
            withCountry = digits
        }

        return Int64(withCountry)
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
