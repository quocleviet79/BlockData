// TGSubscriptionManager.swift
// BlockData

import Foundation
import StoreKit
import Combine

@MainActor
public final class TGSubscriptionManager: ObservableObject {
    public static let shared = TGSubscriptionManager()

    @Published public var isPremium: Bool = false {
        didSet {
            UserDefaults.standard.set(isPremium, forKey: premiumDefaultKey)
        }
    }
    @Published public var weeklyProduct: Product?
    @Published public var lifetimeProduct: Product?
    @Published public var isPurchasing: Bool = false
    @Published public var isRestoring: Bool = false
    @Published public var purchaseError: String? = nil

    /// Optional callback invoked when a purchase transaction succeeds, used for ROAS conversion tracking.
    public var onPurchaseSuccess: ((Product, Transaction) -> Void)?

    private let premiumDefaultKey = "isPremiumUser"
    private var transactionListener: Task<Void, Error>?

    private let productIDs = [
        "com.an.blockcall.weekly",
        "com.an.blockcall.lifetime"
    ]

    public init() {
        self.isPremium = UserDefaults.standard.bool(forKey: premiumDefaultKey)

        transactionListener = Task.detached(priority: .background) {
            for await result in Transaction.updates {
                await self.handleTransactionUpdate(result)
            }
        }

        Task {
            await fetchProducts()
            await checkCurrentEntitlements()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Load Products
    public func fetchProducts() async {
        do {
            let fetched = try await Product.products(for: productIDs)
            for product in fetched {
                if product.id.contains("weekly") {
                    self.weeklyProduct = product
                } else if product.id.contains("lifetime") {
                    self.lifetimeProduct = product
                }
            }
        } catch {
            print("Log: - [TGSubscriptionManager] Failed to fetch products: \(error)")
        }
    }

    // MARK: - Entitlements Check
    public func checkCurrentEntitlements() async {
        var hasActivePremium = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if productIDs.contains(transaction.productID) {
                    if let expirationDate = transaction.expirationDate {
                        if expirationDate > Date() {
                            hasActivePremium = true
                        }
                    } else {
                        hasActivePremium = true
                    }
                }
            }
        }
        updatePremiumStatus(hasActivePremium)
    }

    // MARK: - Purchase
    public func purchase(_ product: Product) async throws {
        isPurchasing = true
        purchaseError = nil

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    updatePremiumStatus(true)
                    onPurchaseSuccess?(product, transaction)
                case .unverified(_, let error):
                    purchaseError = "Verification failed: \(error.localizedDescription)"
                    updatePremiumStatus(false)
                }
            case .userCancelled:
                purchaseError = nil
            case .pending:
                purchaseError = "Purchase is pending approval."
            @unknown default:
                purchaseError = "Unknown purchase result."
            }
        } catch {
            purchaseError = error.localizedDescription
            throw error
        }

        isPurchasing = false
    }

    // MARK: - Restore Purchases
    public func restore() async {
        isRestoring = true
        purchaseError = nil

        do {
            try await AppStore.sync()
            await checkCurrentEntitlements()
        } catch {
            purchaseError = error.localizedDescription
        }

        isRestoring = false
    }

    public func clearPurchaseError() {
        purchaseError = nil
    }

    private func updatePremiumStatus(_ active: Bool) {
        if self.isPremium != active {
            self.isPremium = active
        }
    }

    private func handleTransactionUpdate(_ result: VerificationResult<Transaction>) async {
        if case .verified(let transaction) = result {
            await transaction.finish()
            await checkCurrentEntitlements()
        }
    }
}
