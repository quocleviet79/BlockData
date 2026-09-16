// BlockedNumber.swift
// BlockData

import Foundation

public struct BlockedNumber: Codable, Identifiable, Hashable, Sendable {
    public var id: String { phone }
    public let phone: String
    public let callerID: String
    public let callerType: String
    public let dateAdded: Date

    public init(phone: String, callerID: String, callerType: String, dateAdded: Date = Date()) {
        self.phone = phone
        self.callerID = callerID
        self.callerType = callerType
        self.dateAdded = dateAdded
    }

    public init(from callerInfo: CallerInfo) {
        self.phone = callerInfo.phone
        self.callerID = callerInfo.callerID
        self.callerType = callerInfo.callerType
        self.dateAdded = Date()
    }
}

/// Lịch sử tìm kiếm
public struct SearchHistoryItem: Codable, Identifiable, Hashable, Sendable {
    public var id: String { phone }
    public let phone: String
    public let callerID: String
    public let callerType: String
    public let searchDate: Date

    public init(phone: String, callerID: String, callerType: String, searchDate: Date = Date()) {
        self.phone = phone
        self.callerID = callerID
        self.callerType = callerType
        self.searchDate = searchDate
    }

    public init(from callerInfo: CallerInfo) {
        self.phone = callerInfo.phone
        self.callerID = callerInfo.callerID
        self.callerType = callerInfo.callerType
        self.searchDate = Date()
    }
}
