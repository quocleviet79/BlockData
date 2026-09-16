# BlockData

An open, high-performance on-device Spam & Robocall Detection and CallKit Shield engine for iOS and macOS.

## Features

- 🛡️ **Curated Offline Database**: 14,600+ verified robocall, telemarketer, financial fraud, and impersonation scam numbers.
- ⚡ **Zero-Latency In-Memory Lookup**: Instant caller identification directly on-device without leaking user contacts or call queries to external servers.
- 📞 **Apple CallKit Integration**: Out-of-the-box support for `CXCallDirectoryProvider` to block calls and display caller IDs system-wide.
- 💬 **SMS Spam & Phishing Engine**: Rule-based & regex heuristics to classify deceptive messages, quarantine suspicious links, and filter fraudulent SMS.
- 🔒 **Privacy-First**: Operates 100% offline. No telemetry, no logs, and no external tracking.

---

## Installation via Swift Package Manager

### In Xcode
1. Open your project in Xcode.
2. Go to **File > Add Package Dependencies...**
3. Enter the repository URL:
   ```text
   https://github.com/<YOUR-USERNAME>/BlockData.git
   ```
4. Choose the dependency rule (e.g. `Up to Next Major Version` from `1.0.0`).

### In `Package.swift`
```swift
dependencies: [
    .package(url: "https://github.com/<YOUR-USERNAME>/BlockData.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourAppTarget",
        dependencies: [
            .product(name: "BlockData", package: "BlockData")
        ]
    )
]
```

---

## Quick Start

### 1. Identify an Incoming Caller
```swift
import BlockData

let phoneService = PhoneDataService.shared

if let caller = phoneService.lookup(phoneNumber: "+18005550199") {
    print("Detected: \(caller.name) [Category: \(caller.category)]")
} else {
    print("Number not found in offline scam directory.")
}
```

### 2. Manage User Blocklist
```swift
import BlockData

let blockService = BlockListService.shared

// Add number to personal blocklist
blockService.addBlock(phone: "+14155551234", name: "Persistent Telemarketer")

// Check if blocked
if blockService.isBlocked(phone: "+14155551234") {
    print("Call will be dropped automatically.")
}
```

### 3. Filter Spam SMS
```swift
import BlockData

let smsService = SMSFilterService.shared
let result = smsService.filter(message: "URGENT: Click here to claim your $1000 prize: http://scam.link")

if result.isSpam {
    print("Quarantined SMS: \(result.reason)")
}
```

---

## Minimum Requirements

- **iOS**: 17.0+
- **macOS**: 14.0+
- **Swift**: 5.9+
- **Xcode**: 15.0+

## License

MIT License. See LICENSE for details.
