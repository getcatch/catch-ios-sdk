//
//  BaseEarnRedeemWidgetViewModel.swift
//  Catch
//
//  Created by Lucille Benoit on 11/4/22.
//

import Foundation

// MARK: - BaseWidgetDelegate
protocol BaseWidgetDelegate: AnyObject {
    func updateEarnRedeemMessage(reward: Reward, type: EarnRedeemLabelType)
}

// MARK: - BaseWidgetViewModelInterface
protocol BaseWidgetViewModelInterface {
    var earnRedeemLabelType: EarnRedeemLabelType { get }
    func updatePrice(_ price: Int)
}

// MARK: - BaseEarnRedeemWidgetViewModel
class BaseEarnRedeemWidgetViewModel: BaseWidgetViewModelInterface, NotificationResponding {
    weak var delegate: BaseWidgetDelegate?
    internal var merchant: Merchant?
    internal var rewardsResult: RewardsCalculatorResult?
    internal var earnRedeemLabelType: EarnRedeemLabelType
    internal var amount: Int
    internal var publicUserData: WidgetContentPublicUserData? {
        return rewardsCalculator.getWidgetContentPublicUserData()
    }

    private var items: [Item]?
    private var userCohorts: [String]?

    private let rewardsCalculator: RewardsCalculatorInterface

    // MARK: Initializer
    required init(config: BaseWidgetConfig,
                  delegate: BaseWidgetDelegate,
                  rewardsCalculator: RewardsCalculatorInterface = Catch.rewardsCalculator) {
        self.amount = config.price ?? 0
        self.items = config.items
        self.userCohorts = config.userCohorts
        self.earnRedeemLabelType = config.earnRedeemLabelConfig
        self.delegate = delegate
        self.rewardsCalculator = rewardsCalculator
        subscribeToNotifications()
        calculateEarnedRewards(price: amount, items: items, userCohorts: userCohorts)
    }

    // MARK: Public Functions
    func updatePrice(_ price: Int) {
        self.amount = max(0, price)
        calculateEarnedRewards(price: price, items: items, userCohorts: userCohorts)
    }

    // MARK: Private Helpers
    internal func didReceiveNotification(_ notification: Notification) {
        fetchCalculatedEarnedRewards()
    }

    private func calculateEarnedRewards(price: Int, items: [Item]?, userCohorts: [String]?) {
        fetchCalculatedEarnedRewards()
    }

    private func fetchCalculatedEarnedRewards() {
        self.rewardsCalculator.fetchCalculatedEarnedReward(price: amount,
                                                           items: items,
                                                           userCohorts: userCohorts) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let rewardsCalculatorResult):
                    let reward = rewardsCalculatorResult.prioritizedReward
                    self.rewardsResult = rewardsCalculatorResult
                    self.delegate?.updateEarnRedeemMessage(reward: reward, type: self.earnRedeemLabelType)
                case .failure(let error):
                    Logger.log(error: error)
            }
        }
    }

    private func subscribeToNotifications() {
        // Rewards should be recalculated if the merchant or device token changes
        // or if the application re-enters the active state to ensure data isn't stale.
        subscribeToMerchantUpdates()
        subscribeToDeviceTokenUpdates()
        subscribeToApplicationDidBecomeActiveNotification()
    }
}
