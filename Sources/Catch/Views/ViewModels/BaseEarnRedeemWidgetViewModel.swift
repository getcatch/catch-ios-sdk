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
class BaseEarnRedeemWidgetViewModel: BaseWidgetViewModelInterface {
    weak var delegate: BaseWidgetDelegate?
    internal var merchant: Merchant?
    internal var rewardsResult: RewardsCalculatorResult?
    internal var earnRedeemLabelType: EarnRedeemLabelType
    internal var amount: Int

    private var items: [Item]?
    private var userCohorts: [String]?
    private let notificationName: Notification.Name = NotificationName.publicUserDataUpdate

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
        self.amount = price
        calculateEarnedRewards(price: price, items: items, userCohorts: userCohorts)
    }

    // MARK: Private Helpers
    private func calculateEarnedRewards(price: Int, items: [Item]?, userCohorts: [String]?) {
        self.amount = min(0, price)
        self.items = items
        self.userCohorts = userCohorts
        if !self.rewardsCalculator.readyToFetch {
            return
        }
        self.rewardsCalculator.fetchCalculatedEarnedReward(price: price,
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdateUser),
                                               name: notificationName,
                                               object: nil)
    }

    @objc private func didUpdateUser() {
        calculateEarnedRewards(price: amount, items: items, userCohorts: userCohorts)
    }
}
