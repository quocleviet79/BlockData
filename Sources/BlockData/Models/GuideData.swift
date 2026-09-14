// GuideData.swift
// BlockData

import Foundation

public enum GuideData: CaseIterable, Identifiable, Sendable {
    case consumerTips
    case robocalls
    case robotexts
    case spoofing
    case politicalCallAndTexts
    case callBlockingResource
    case donotCallList

    public var id: Self { self }

    public var title: String {
        switch self {
        case .consumerTips:
            return "Consumer Tips"
        case .robocalls:
            return "Robocalls Protection"
        case .robotexts:
            return "Robotexts Defense"
        case .spoofing:
            return "Caller ID Spoofing"
        case .politicalCallAndTexts:
            return "Political Calls & Texts"
        case .callBlockingResource:
            return "Call Blocking Resources"
        case .donotCallList:
            return "Do Not Call Registry"
        }
    }

    public var content: String {
        switch self {
        case .consumerTips:
            return "Don't answer calls from unknown numbers. If you answer and the caller asks you to hit a button to stop getting calls, just hang up."
        case .robocalls:
            return "Scammers can use the internet to make calls from all over the world. They can spoof numbers to make them look local or like a trusted company."
        case .robotexts:
            return "Never click links in text messages from unknown senders. Forward suspected scam texts to 7726 (SPAM)."
        case .spoofing:
            return "Spoofing is when a caller deliberately falsifies the information transmitted to your caller ID display to disguise their identity."
        case .politicalCallAndTexts:
            return "Political campaign-related robocalls and robotexts are subject to specific FCC rules and opt-out regulations."
        case .callBlockingResource:
            return "Use modern Call Directory extension filtering and iOS Silence Unknown Callers features to stay protected."
        case .donotCallList:
            return "Register your home and mobile numbers with the National Do Not Call Registry to reduce unwanted sales calls."
        }
    }
}
