// CallerInfo.swift
// BlockData

import Foundation

/// Một entry trong data.json
public struct CallerInfo: Codable, Identifiable, Hashable, Sendable {
    public var id: String { phone }

    public let phone: String
    public let callerID: String
    public let callerType: String

    public enum CodingKeys: String, CodingKey {
        case phone
        case callerID   = "caller_id"
        case callerType = "caller_type"
    }

    public init(phone: String, callerID: String, callerType: String) {
        self.phone = phone
        self.callerID = callerID
        self.callerType = callerType
    }

    /// Trả về spam score đơn giản dựa theo callerType
    public var spamLevel: SpamLevel {
        let type = callerType.lowercased()
        if type.contains("scam") || type.contains("fraud") || type.contains("unknown robocaller") {
            return .high
        } else if type.contains("spam") || type.contains("robocall") || type.contains("alert") {
            return .medium
        } else {
            return .low
        }
    }

    public var spamScore: Int {
        switch spamLevel {
        case .high:   return 90
        case .medium: return 55
        case .low:    return 20
        }
    }
}

public enum SpamLevel: Sendable {
    case high, medium, low

    public var label: String {
        switch self {
        case .high:   return "High Risk"
        case .medium: return "Medium Risk"
        case .low:    return "Low Risk"
        }
    }

    public var color: String {
        switch self {
        case .high:   return "red"
        case .medium: return "orange"
        case .low:    return "green"
        }
    }
}

/// Wrapper dùng cho data.json (có timestamp + data array)
public struct PhoneDataResponse: Codable, Sendable {
    public struct Timestamp: Codable, Sendable {
        public let year: Int
        public let month: Int

        public init(year: Int, month: Int) {
            self.year = year
            self.month = month
        }
    }
    public let timestamp: Timestamp
    public let data: [CallerInfo]

    public init(timestamp: Timestamp, data: [CallerInfo]) {
        self.timestamp = timestamp
        self.data = data
    }
}
