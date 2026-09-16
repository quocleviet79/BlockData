// GuideData.swift
// BlockData
//
// Authoritative security and scam defense handbook guides.
// Provides in-depth analysis, warning signs, and action plans for call & SMS protection.

import Foundation

public enum GuideData: String, CaseIterable, Identifiable, Sendable {
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
            return "Consumer Defense Tips"
        case .robocalls:
            return "Robocalls & AI Voice Scams"
        case .robotexts:
            return "Robotexts & Smishing Defense"
        case .spoofing:
            return "Caller ID & Neighbor Spoofing"
        case .politicalCallAndTexts:
            return "Political Outreach & Opt-Outs"
        case .callBlockingResource:
            return "Call Blocking Technologies"
        case .donotCallList:
            return "Do Not Call Registry & Rights"
        }
    }

    public var subtitle: String {
        switch self {
        case .consumerTips:
            return "Essential golden rules to protect your identity, finances, and personal privacy from fraudulent callers."
        case .robocalls:
            return "How automated dialing systems and synthetic voice cloning work, and strategies to stop them."
        case .robotexts:
            return "Recognizing malicious SMS, deceptive parcel tracking links, and smishing attacks."
        case .spoofing:
            return "Understanding how scammers forge display numbers and simulate local area codes to trick you."
        case .politicalCallAndTexts:
            return "Navigating campaign season outreach, regulatory exemptions, and how to enforce opt-out requests."
        case .callBlockingResource:
            return "Combining on-device CallKit directories, carrier network filters, and Apple privacy controls."
        case .donotCallList:
            return "Registering with the National Do Not Call Registry, coverage limitations, and filing FTC complaints."
        }
    }

    public var systemImage: String {
        switch self {
        case .consumerTips:
            return "shield.lefthalf.filled"
        case .robocalls:
            return "phone.bubble.left.fill"
        case .robotexts:
            return "message.badge.filled.fill"
        case .spoofing:
            return "person.crop.circle.badge.exclamationmark"
        case .politicalCallAndTexts:
            return "megaphone.fill"
        case .callBlockingResource:
            return "gearshape.2.fill"
        case .donotCallList:
            return "list.bullet.clipboard.fill"
        }
    }

    public var category: String {
        switch self {
        case .consumerTips:
            return "Safety Basics"
        case .robocalls:
            return "Robocall Defense"
        case .robotexts:
            return "SMS Security"
        case .spoofing:
            return "Tech Awareness"
        case .politicalCallAndTexts:
            return "Regulations"
        case .callBlockingResource:
            return "Setup Guide"
        case .donotCallList:
            return "Legal Rights"
        }
    }

    public var readTime: String {
        switch self {
        case .consumerTips:
            return "3 min read"
        case .robocalls:
            return "4 min read"
        case .robotexts:
            return "4 min read"
        case .spoofing:
            return "3 min read"
        case .politicalCallAndTexts:
            return "3 min read"
        case .callBlockingResource:
            return "4 min read"
        case .donotCallList:
            return "3 min read"
        }
    }

    public var keyTakeaways: [String] {
        switch self {
        case .consumerTips:
            return [
                "Never share two-factor SMS authentication codes or banking passwords over an unsolicited call.",
                "Legitimate organizations will never demand immediate payment through gift cards, wire transfers, or cryptocurrency.",
                "If in doubt, hang up and dial the official number found on your physical card or official website.",
                "Do not say 'Yes' to unfamiliar questions like 'Can you hear me?' to prevent voice authorization recording scams."
            ]
        case .robocalls:
            return [
                "Interacting with an automated prompt (such as 'Press 1 to opt out') confirms your line is active and triggers more calls.",
                "Modern scammers harvest short social media clips to clone voices of family members or officials.",
                "Establish a secret family code word to verify emergency distress calls.",
                "Combine on-device CallKit blocking with carrier network scam shields for full coverage."
            ]
        case .robotexts:
            return [
                "Never tap links in unexpected parcel delivery failure notices or urgent bank suspension alerts.",
                "Forward suspicious or fraudulent text messages to 7726 (SPAM) to alert cellular networks.",
                "Banks and government agencies never send direct links requesting full card numbers, CVVs, or PINs.",
                "Avoid texting 'STOP' to unknown random phone numbers, as this confirms your phone number is valid."
            ]
        case .spoofing:
            return [
                "Caller ID displays can easily be manipulated by fraudsters using VoIP tools to show any name or number.",
                "'Neighbor spoofing' mimics your local area code and exchange to make unknown calls look familiar.",
                "Scammers often spoof the actual customer service number of your local utility, police, or bank.",
                "Always verify identity by calling back via an independently verified telephone directory."
            ]
        case .politicalCallAndTexts:
            return [
                "Political campaigns, public opinion surveys, and charities are exempt from the National Do Not Call Registry.",
                "Automated pre-recorded political robocalls to mobile phones still require prior express consent under FCC rules.",
                "Peer-to-peer political text campaigns are legally required to honor opt-out replies such as 'STOP' or 'UNSUBSCRIBE'.",
                "Use WhoIsCalling's custom blacklist or iOS SMS filtering to minimize election season distractions."
            ]
        case .callBlockingResource:
            return [
                "iOS CallKit extensions run 100% locally on-device, preserving full privacy with zero data leakage.",
                "Enable 'Silence Unknown Callers' in iOS Settings to route unknown numbers straight to voicemail.",
                "Activate free carrier security features (AT&T ActiveArmor, Verizon Call Filter, T-Mobile Scam Shield).",
                "Regularly refresh the WhoIsCalling database to ensure newly reported fraudulent numbers are blocked."
            ]
        case .donotCallList:
            return [
                "Registration on the National Do Not Call Registry (DoNotCall.gov) is 100% free and never expires.",
                "Lawful telemarketers must stop calling registered numbers within 31 days of registration.",
                "Illegal scam operations intentionally disregard the registry; cold calls from them are immediate red flags.",
                "File formal complaints with the FTC at ReportFraud.ftc.gov to assist global enforcement actions."
            ]
        }
    }

    public var content: String {
        switch self {
        case .consumerTips:
            return """
### 1. The Reality of Cold Calls
Fraudulent phone calls have evolved far beyond simple sales pitches. Modern scammers run coordinated, highly convincing operations posing as government officials, bank fraud departments, courier services, or utility providers. The first rule of telephone safety is simple: never trust incoming call claims without independent verification.

### 2. Beware the Urgency & Fear Trap
Scammers manipulate human psychology through artificial urgency. They may claim that your bank account is compromised, a warrant has been issued for your arrest, or your electricity will be disconnected within the hour. Real institutions will always provide written notices and allow you reasonable time to verify your account status.

### 3. The "Can You Hear Me?" Voice Trap
Be cautious when an unfamiliar caller immediately asks questions like "Can you hear me?" or "Is this the homeowner?". Scammers frequently record your verbal "Yes" to fabricate consent for fraudulent credit card charges or telephone service sign-ups. If you answer an unknown call, say "I can hear you" or hang up immediately.

### 4. Golden Rules for Everyday Protection
- **Never Disclose OTPs**: One-Time Passwords (OTPs) are meant for your eyes only. No bank employee will ever ask you to read back an SMS verification code.
- **Untraceable Payment Demands**: If anyone asks for payment via Apple Gift Cards, Google Play cards, Western Union, or Bitcoin, it is 100% a scam.
- **Hang Up and Call Back**: If someone claims to be from your bank or credit card company, immediately hang up. Turn over your card, find the official customer care number on the back, and call back directly.
- **Report & Block**: Add the number to your WhoIsCalling blocklist and report the incident to consumer protection agencies.
"""

        case .robocalls:
            return """
### 1. How Modern Robocalls Operate
Robocalls are automated telephone calls made by computerized auto-dialing systems capable of dialing thousands of numbers every second. Scammers use Voice over IP (VoIP) platforms located overseas to cheaply flood cellular networks with deceptive, pre-recorded messages.

### 2. The Rise of AI Voice Cloning
With recent advancements in artificial intelligence and deepfake voice synthesis, criminals now only need 3 to 5 seconds of clean audio—often extracted from public social media videos—to accurately clone a person's voice. They frequently run the "Family Emergency" or "Grandparent Scam", where a frantic voice sounding exactly like a son, daughter, or grandchild claims to be in jail or hospital and desperately needs money.

### 3. Why "Press 1 to Unsubscribe" Is a Lie
Many robocalls include a prompt claiming: "Press 1 to speak with an agent, or press 9 to be placed on our do not call list." Do not press any keys! Pressing a button signals to the automated system that your line is active and that a human is listening. Your phone number will be tagged as high-value and sold to other telemarketing networks, leading to a dramatic surge in unwanted calls.

### 4. Defense Strategies to Silence Robocalls
- **Establish a Family Safe Word**: Agree on a unique, confidential code word with close family members. In any emergency call asking for money, ask for the code word to verify authenticity.
- **Let Unknown Calls Go to Voicemail**: If an unknown number is truly important, legitimate callers will leave a voicemail. Scammers rarely do.
- **Use On-Device Identification**: WhoIsCalling's local Call Directory extension intercepts known scam numbers before your phone rings, protecting your attention and peace of mind.
"""

        case .robotexts:
            return """
### 1. Understanding Smishing (SMS Phishing)
Smishing combines SMS text messages with phishing tactics. Criminals send billions of deceptive text messages each year designed to provoke immediate panic, curiosity, or greed, with the ultimate goal of getting you to click a malicious link or reveal personal data.

### 2. Common Smishing Scenarios to Watch For
- **Fake Parcel Delivery Alerts**: "USPS/FedEx/DHL: Your package cannot be delivered due to incomplete address details. Update your information here: [malicious-link.cc]".
- **Urgent Banking Suspension**: "Security Alert: Your debit card has been restricted due to suspicious activity. Verify your identity immediately to restore access."
- **Unpaid Tolls & Parking Invoices**: "SunPass/E-ZPass: You have an unpaid toll balance of $12.50. Surcharges apply after midnight: [phishing-link]".
- **Job & Lottery Lures**: Unsolicited job offers offering $500/day for remote tasks, or claims that you won an Amazon contest you never entered.

### 3. The Dangers of Tapping Links
Tapping links in fraudulent SMS messages can direct you to sophisticated spoofed websites that look identical to real login portals. Entering your login credentials, credit card details, or Social Security Number hands your identity directly to criminals. In some cases, the link may attempt to install spyware or malicious configuration profiles on your device.

### 4. What to Do When You Receive a Suspicious Text
- **Never Tap the Link**: Do not open the URL, even out of curiosity.
- **Do Not Reply "STOP"**: Replying to unknown random numbers only validates that your number is active.
- **Forward to 7726 (SPAM)**: Forward the fraudulent text message to 7726 on major carriers (AT&T, Verizon, T-Mobile, etc.). This free service helps carriers block the sender across their entire network.
- **Leverage WhoIsCalling AI Filter**: Let the app automatically analyze incoming SMS patterns and quarantine potential scam links into your spam folder.
"""

        case .spoofing:
            return """
### 1. What Is Caller ID Spoofing?
Caller ID spoofing occurs when a caller intentionally disguises the information transmitted to your caller ID display to conceal their true identity. Because legacy telephone networks were not designed with cryptographic authentication, any VoIP caller can customize their outgoing caller number and name to match any desired telephone number.

### 2. The Danger of "Neighbor Spoofing"
Scammers know that consumers rarely answer out-of-state or toll-free numbers. To counter this, they use "neighbor spoofing"—generating calls that display your local area code and the first three digits of your phone number. You might believe it is your neighbor, a local business, or your child's school calling, prompting you to pick up.

### 3. Impersonating Official Institutions
Scammers frequently spoof legitimate telephone numbers belonging to:
- The Internal Revenue Service (IRS) or Tax Authorities
- Local Police Departments or Sheriffs' Offices
- Fraud Departments of major banks (Chase, Wells Fargo, Bank of America)
- Utility companies (electric, water, gas)

Even if your caller ID accurately matches the official telephone number printed on your bank statement, the call itself may still be spoofed.

### 4. How to Defend Against Spoofed Calls
- **Never Rely on Caller ID Alone**: Always treat incoming caller ID displays as unverified claims, not proof of identity.
- **Verify Through Secondary Channels**: If an agency claims you owe money or that your account is locked, state that you will call back. Hang up, wait 30 seconds (to ensure the line has disconnected), and dial the official public number.
- **Support STIR/SHAKEN Standards**: Telecommunication carriers are progressively implementing STIR/SHAKEN call verification, which places a checkmark next to verified caller IDs.
"""

        case .politicalCallAndTexts:
            return """
### 1. Political Communications & Legal Exceptions
During election seasons, voters often experience an avalanche of campaign calls and text messages. Many people wonder why these communications arrive even after registering on the National Do Not Call Registry. The reason: federal law explicitly exempts political candidates, political parties, and ballot measure committees from commercial telemarketing restrictions under First Amendment free speech protections.

### 2. Robocalls vs. Peer-to-Peer (P2P) Texting
Federal Communications Commission (FCC) rules establish clear distinctions between different types of political communications:
- **Political Robocalls**: Pre-recorded automated calls to mobile phones without prior express consent are illegal. However, automated calls to landline phones are generally allowed.
- **Robotexts**: Autodialed mass text messages without consent are prohibited.
- **Peer-to-Peer (P2P) Texts**: Campaigns employ specialized software where a human volunteer presses a button to initiate each individual message. Because a human initiates each message, P2P texting is legally permitted without prior opt-in consent.

### 3. How to Effectively Opt Out
Under federal guidelines and carrier codes of conduct, political campaigns must honor opt-out requests:
- Simply reply with **"STOP"**, **"UNSUBSCRIBE"**, or **"QUIT"**.
- Legitimate campaigns use automated systems that immediately flag your number as opted-out and prevent subsequent messages from that campaign's platform.
- Note that opting out of one candidate's campaign does not automatically opt you out of others, as each organization operates separate donor and voter databases.

### 4. Maintaining Digital Peace
Use WhoIsCalling's custom blacklist to instantly drop numbers from persistent political action committees (PACs), or activate iOS message filtering to separate unknown political texts from your personal conversations.
"""

        case .callBlockingResource:
            return """
### 1. Apple CallKit Architecture: Privacy First
Apple designed the iOS CallKit framework with an unwavering commitment to personal privacy. Unlike traditional platforms that require uploading your entire address book to third-party servers, WhoIsCalling's Call Directory extension operates 100% on your device:
- The app compiles curated databases of malicious phone numbers into high-speed binary lookups.
- When an incoming call arrives, the iOS system kernel checks the offline list in zero milliseconds.
- WhoIsCalling never learns who is calling you, when you receive calls, or what numbers you dial.

### 2. Silence Unknown Callers (iOS Native Feature)
Apple includes a powerful built-in feature designed to eliminate nuisance calls:
- Navigate to **Settings > Phone > Silence Unknown Callers**.
- When activated, calls from numbers not saved in your Contacts, recent outgoing calls, or Siri Suggestions will be silenced automatically and sent straight to voicemail.
- Your phone will not ring, but the call will still appear in your Recents list and you will receive voicemail notifications if they leave a message.

### 3. Carrier-Provided Spam Protections
Major wireless carriers provide network-level spam filtering that works in tandem with WhoIsCalling:
- **AT&T**: ActiveArmor app provides automatic fraud call blocking and spam risk warnings.
- **Verizon**: Call Filter detects and filters suspected spam calls at the network perimeter.
- **T-Mobile**: Scam Shield includes Scam Block (dial #662# to turn on network-wide scam drop).

### 4. The Multi-Layered Defense Shield
The most robust defense strategy combines:
1. **Network Layer**: Free carrier scam protection for network-level drops.
2. **On-Device Layer**: WhoIsCalling Call Directory extension with 14,600+ offline records for instant caller ID and auto-blocking.
3. **Personal Layer**: Your personal WhoIsCalling blocklist for customized, immediate number silencing.
"""

        case .donotCallList:
            return """
### 1. What Is the National Do Not Call Registry?
Created in 2003 by the Federal Trade Commission (FTC) and the FCC, the National Do Not Call Registry offers consumers a free, permanent method to reduce unwanted telemarketing calls from legitimate, law-abiding commercial sales operations.

### 2. How to Register Your Numbers
- **Online**: Visit **DoNotCall.gov** and enter up to three phone numbers along with your email address for confirmation.
- **By Phone**: Call **1-888-382-1222** (TTY: 1-866-290-4236) from the exact telephone number you wish to register.
- **No Expiration**: Once registered, your numbers remain on the list permanently until you choose to remove them or disconnect the phone line.

### 3. What the Registry Covers & Important Exemptions
Commercial telemarketers are required by federal law to cross-reference their call lists against the National Registry every 31 days and cease unsolicited calling to registered numbers. However, the registry does **NOT** stop:
- Political candidate and campaign calls
- Charitable donation solicitations
- Customer satisfaction surveys and informational polls
- Companies with which you have an existing business relationship (within the past 18 months)
- Debt collection communications

### 4. Why You Still Receive Scam Calls
The National Do Not Call Registry is a regulatory compliance tool for legitimate businesses. Criminal scammers intentionally ignore the law, operate offshore, and use fake caller IDs. Therefore, if you receive a cold sales call on a registered number, you can immediately recognize it as a fraudulent operation.

### 5. Filing Effective Complaints
When an unlawful caller targets you:
- Document the exact time, date, caller ID number, and company name.
- Submit a complaint at **ReportFraud.ftc.gov** or **DoNotCall.gov**.
- Federal regulatory agencies aggregate consumer complaints to coordinate criminal indictments, assess multimillion-dollar fines, and shut down illegal telecom gateways.
"""
        }
    }
}
