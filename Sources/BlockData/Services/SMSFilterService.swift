// SMSFilterService.swift
// BlockData

import Foundation
import Combine
import SwiftUI

@MainActor
public final class SMSFilterService: ObservableObject {
    public static let shared = SMSFilterService()

    @Published public private(set) var filters: [Filter] = []
    @Published public var filterError: FilterError?
    @Published public var importedFilters: [Filter] = []
    @Published public var filterImportInProgress: Bool = false

    private static let filterListFile = "filters.json"

    private static var fileURL: URL? {
        return FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroup)?
            .appendingPathComponent(filterListFile)
    }

    public init() {
        loadFilters()
    }

    // MARK: - Load / Save

    public func loadFilters() {
        if let data = sharedDefaults?.data(forKey: "filters.json"),
           let decoded = try? JSONDecoder().decode([Filter].self, from: data) {
            filters = decoded
            return
        }

        guard let url = Self.fileURL else {
            loadDefaultFilters()
            return
        }

        if !FileManager.default.fileExists(atPath: url.path) {
            loadDefaultFilters()
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Filter].self, from: data)
            filters = decoded
        } catch {
            print("⚠️ SMSFilterService load error: \(error)")
            loadDefaultFilters()
        }
    }

    private func loadDefaultFilters() {
        let defaults: [Filter] = [
            Filter(phrase: "casino", type: .any, action: .junk),
            Filter(phrase: "lottery", type: .any, action: .junk),
            Filter(phrase: "crypto bonus", type: .message, action: .junk),
            Filter(phrase: "urgent verify your account", type: .message, action: .junk),
            Filter(phrase: "claim prize", type: .message, action: .junk)
        ]
        saveToDisk(defaults)
        filters = defaults
    }

    @discardableResult
    private func saveToDisk(_ items: [Filter]) -> Bool {
        if let data = try? JSONEncoder().encode(items) {
            sharedDefaults?.set(data, forKey: "filters.json")
            sharedDefaults?.synchronize()
        }

        guard let url = Self.fileURL else { return true }
        do {
            try JSONEncoder().encode(items).write(to: url)
            return true
        } catch {
            print("❌ SMSFilterService save error: \(error)")
            return false
        }
    }

    // MARK: - CRUD

    public func add(filter: Filter) {
        var updated = filters
        updated.append(filter)
        updated = updated.sorted { $0.phrase < $1.phrase }
        if saveToDisk(updated) {
            filters = updated
        }
    }

    public func addMany(newFilters: [Filter]) {
        var updated = filters
        for f in newFilters {
            if !updated.contains(f) {
                updated.append(f)
            }
        }
        updated = updated.sorted { $0.phrase < $1.phrase }
        if saveToDisk(updated) {
            filters = updated
        }
    }

    public func update(filter: Filter) {
        var updated = filters
        if let idx = updated.firstIndex(where: { $0.id == filter.id }) {
            updated[idx] = filter
            if saveToDisk(updated) {
                filters = updated
            }
        }
    }

    public func remove(uuid: UUID) {
        let updated = filters.filter { $0.id != uuid }
        if saveToDisk(updated) {
            filters = updated
        }
    }

    public func remove(at offsets: IndexSet) {
        var updated = filters
        updated.remove(atOffsets: offsets)
        if saveToDisk(updated) {
            filters = updated
        }
    }

    public func reset() {
        loadDefaultFilters()
    }

    // MARK: - Import / Export

    public func importFromURL(_ url: URL) {
        do {
            _ = url.startAccessingSecurityScopedResource()
            let data = try Data(contentsOf: url)
            let imported = try JSONDecoder().decode([Filter].self, from: data)
            url.stopAccessingSecurityScopedResource()

            if imported.isEmpty {
                filterError = .emptyImportFileError
                return
            }

            filterImportInProgress = true
            importedFilters = imported
        } catch {
            filterError = .decodingError(error.localizedDescription)
        }
    }

    public func commitImport() {
        addMany(newFilters: importedFilters)
        importedFilters = []
        filterImportInProgress = false
    }

    public func cancelImport() {
        importedFilters = []
        filterImportInProgress = false
    }

    public func exportURL() -> URL? {
        guard let url = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("filters_export.json"),
              let data = try? JSONEncoder().encode(filters) else { return nil }
        try? data.write(to: url)
        return url
    }

    // MARK: - Filtering Logic

    public func filterMessage(message: SMSMessage) -> ILMessageFilterActionResult {
        for filter in filters {
            if matchesFilter(filter, message: message) {
                return ILMessageFilterActionResult(action: filter.action)
            }
        }
        return ILMessageFilterActionResult(action: .none)
    }

    public func matchesFilter(_ filter: Filter, message: SMSMessage) -> Bool {
        let haystack: String
        switch filter.type {
        case .any:     haystack = "\(message.sender) \(message.text)"
        case .sender:  haystack = message.sender
        case .message: haystack = message.text
        }

        let needle = filter.phrase
        if filter.useRegex {
            let options: NSRegularExpression.Options = filter.caseSensitive ? [] : .caseInsensitive
            guard let regex = try? NSRegularExpression(pattern: needle, options: options) else { return false }
            return regex.firstMatch(in: haystack, range: NSRange(haystack.startIndex..., in: haystack)) != nil
        } else {
            let options: String.CompareOptions = filter.caseSensitive ? [] : .caseInsensitive
            return haystack.range(of: needle, options: options) != nil
        }
    }
}

public struct ILMessageFilterActionResult: Sendable {
    public let action: FilterDestination

    public init(action: FilterDestination) {
        self.action = action
    }
}
