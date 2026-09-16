// SMSFilterModels.swift
// BlockData

import Foundation

// MARK: - Filter Types

public enum FilterType: String, Codable, Equatable, CaseIterable, Sendable {
    case any
    case sender
    case message

    public var displayName: String {
        switch self {
        case .any:     return "Any"
        case .sender:  return "Sender"
        case .message: return "Message"
        }
    }
}

public enum FilterDestination: String, Codable, Equatable, CaseIterable, Sendable {
    case none
    case junk
    case transaction
    case promotion
    case transactionOrder
    case transactionFinance
    case transactionReminders
    case transactionHealth
    case transactionOther
    case promotionOffers
    case promotionCoupons
    case promotionOther

    public var displayName: String {
        switch self {
        case .none:                  return "None"
        case .junk:                  return "Junk"
        case .transaction:           return "Transaction"
        case .promotion:             return "Promotion"
        case .transactionOrder:      return "Orders"
        case .transactionFinance:    return "Finance"
        case .transactionReminders:  return "Reminders"
        case .transactionHealth:     return "Health"
        case .transactionOther:      return "Other"
        case .promotionOffers:       return "Offers"
        case .promotionCoupons:      return "Coupons"
        case .promotionOther:        return "Other"
        }
    }
}

public struct Filter: Hashable, Identifiable, Equatable, Codable, Sendable {
    public var id: UUID
    public var type: FilterType
    public var phrase: String
    public var action: FilterDestination
    public var subAction: FilterDestination
    public var caseSensitive: Bool = false
    public var useRegex: Bool = false

    public init(id: UUID = UUID(),
                phrase: String,
                type: FilterType = .any,
                action: FilterDestination = .junk,
                subAction: FilterDestination = .none,
                useRegex: Bool = false,
                caseSensitive: Bool = false) {
        self.id = id
        self.type = type
        self.phrase = phrase
        self.action = action
        self.subAction = subAction
        self.useRegex = useRegex
        self.caseSensitive = caseSensitive
    }
}

// MARK: - SMS Message

public struct SMSMessage: Sendable {
    public var sender: String
    public var text: String

    public init(sender: String, text: String) {
        self.sender = sender
        self.text = text
    }
}

// MARK: - Errors

public enum FilterStoreError: Error, Sendable {
    case loadError
    case decodingError
    case addError
    case updateError
    case deleteError
    case diskError(String)
    case other
}

public enum FilterMiddlewareError: Error, Sendable {
    case fetchError(FilterStoreError)
    case addError(FilterStoreError)
    case updateError(FilterStoreError)
    case deleteError(FilterStoreError)
}

public enum FilterError: Identifiable, Sendable {
    case emptyImportFileError
    case decodingError(String)
    case unknownError(String)

    public var id: String {
        switch self {
        case .emptyImportFileError:       return "EMPTY_IMPORT_FILE"
        case .decodingError:              return "INCORRECT_FILE_FORMAT"
        case let .unknownError(str):      return str
        }
    }

    public var message: String {
        switch self {
        case .emptyImportFileError:       return "Import file is empty"
        case let .decodingError(str):     return "Import error: \(str)"
        case let .unknownError(str):      return "Unknown error: \(str)"
        }
    }
}
