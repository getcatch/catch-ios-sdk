//
//  PurchaseConfirmationViewModel.swift
//  Catch
//
//  Created by Lucille Benoit on 11/4/22.
//

import Foundation

protocol PurchaseConfirmationViewModelDelegate: AnyObject {
    func updateCardData(amount: Int, expiration: Date?, merchant: Merchant?)
    func updateEarnRedeemMessage(reward: Reward, type: EarnRedeemLabelType)
}

class PurchaseConfirmationViewModel: BaseWidgetViewModelInterface, MerchantSubscribing {

    weak var delegate: PurchaseConfirmationViewModelDelegate?

    internal var earnRedeemLabelType: EarnRedeemLabelType {
        return .purchaseConfirmation(merchantName: merchantName, amountEarned: amount)
    }

    private var amount: Int {
        didSet {
            updateViews()
        }
    }

    private var merchant: Merchant?

    private var merchantName: String {
        return merchant?.name ?? LocalizedString.thisStore.localized
    }

    // MARK: - Initializers

    required init(config: BaseWidgetConfig,
                  delegate: PurchaseConfirmationViewModelDelegate,
                  merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository) {
        let amountEarned = config.price ?? 0
        self.amount = amountEarned
        self.delegate = delegate
        self.merchant = merchantRepository.getCurrentMerchant()
        updateViews()
        subscribeToMerchantUpdates()
    }

    func updatePrice(_ price: Int) {
        self.amount = price
    }

    func handleMerchantNotification(merchant: Merchant) {
        self.merchant = merchant
        updateViews()
    }
}

// MARK: - Private Helpers
private extension PurchaseConfirmationViewModel {

    private func updateViews() {
        var expirationDate: Date?
        if let merchant = merchant {
            expirationDate = Date().byAdding(days: merchant.rewardsLifetimeInDays)
        }

        delegate?.updateEarnRedeemMessage(reward: .earnedCredits(amount), type: earnRedeemLabelType)
        delegate?.updateCardData(amount: amount, expiration: expirationDate, merchant: merchant)
    }
}
