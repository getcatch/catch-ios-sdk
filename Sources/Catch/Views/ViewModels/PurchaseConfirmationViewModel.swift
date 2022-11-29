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

class PurchaseConfirmationViewModel: BaseCardViewModel {

    // MARK: Properties
    weak var delegate: PurchaseConfirmationViewModelDelegate?

    internal var textLabelType: EarnRedeemLabelType {
        return .purchaseConfirmation(merchantName: merchantName, amountEarned: amount)
    }

    internal var amount: Int {
        didSet {
            updateMerchantViews()
        }
    }

    // MARK: - Initializers

    required init(config: BaseWidgetConfig,
                  delegate: PurchaseConfirmationViewModelDelegate,
                  merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository) {
        let amountEarned = config.price ?? 0
        self.amount = amountEarned
        self.delegate = delegate
        super.init()
        self.merchantUpdatingDelegate = self
        updateMerchantViews()
    }

    func updateEarnedAmount(_ amount: Int) {
        self.amount = amount
    }

}

// MARK: - BaseCardViewModel Conformance
extension PurchaseConfirmationViewModel: MerchantRespondingDelegate {

    internal func updateMerchantViews() {
        var expirationDate: Date?
        if let merchant = merchant {
            expirationDate = Date().byAdding(days: merchant.rewardsLifetimeInDays)
        }

        delegate?.updateEarnRedeemMessage(reward: .earnedCredits(amount), type: textLabelType)
        delegate?.updateCardData(amount: amount, expiration: expirationDate, merchant: merchant)
    }
}
