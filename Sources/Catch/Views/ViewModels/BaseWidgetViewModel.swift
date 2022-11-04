//
//  BaseWidgetViewModel.swift
//  Catch
//
//  Created by Lucille Benoit on 11/4/22.
//

import Foundation

// MARK: - BaseWidgetDelegate
protocol BaseWidgetDelegate: AnyObject {
    func didUpdateEarnRedeemMessageData()
}

// MARK: - BaseWidgetViewModelInterface
protocol BaseWidgetViewModelInterface {
    var merchant: Merchant? { get }
    var reward: Reward? { get }
    var earnRedeemLabelType: EarnRedeemLabelType? { get }
    func updatePrice(_ price: Int)
}

// MARK: - BaseWidgetViewModel
class BaseWidgetViewModel: BaseWidgetViewModelInterface {
    weak var delegate: BaseWidgetDelegate?
    internal var merchant: Merchant?
    internal var reward: Reward?
    internal var earnRedeemLabelType: EarnRedeemLabelType?

    private let price: Int
    private let items: [Item]?
    private let userCohorts: [String]?
    private let notificationName: Notification.Name = NotificationName.publicUserDataUpdate
    private let semaphore = DispatchSemaphore(value: 0)
    private let serialQueue = DispatchQueue(label: "Queue")

    private let rewardsCalculator: RewardsCalculatorInterface

    // MARK: Initializer
    required init(config: BaseWidgetConfig,
                  delegate: BaseWidgetDelegate,
                  rewardsCalculator: RewardsCalculatorInterface = Catch.rewardsCalculator) {
        self.price = config.price ?? 0
        self.items = config.items
        self.userCohorts = config.userCohorts
        self.earnRedeemLabelType = config.earnRedeemLabelConfig
        self.delegate = delegate
        self.rewardsCalculator = rewardsCalculator
        subscribeToNotifications()
        calculateEarnedRewards(price: price, items: items, userCohorts: userCohorts)
    }

    // MARK: Public Functions
    func updatePrice(_ price: Int) {
        calculateEarnedRewards(price: price, items: items, userCohorts: userCohorts)
    }

    // MARK: Private Helpers
    private func calculateEarnedRewards(price: Int, items: [Item]?, userCohorts: [String]?) {
        serialQueue.async { [unowned self] in
            if !self.rewardsCalculator.readyToFetch {
                self.semaphore.wait()
            }
            self.rewardsCalculator.fetchCalculatedEarnedReward(price: price,
                                                               items: items,
                                                               userCohorts: userCohorts) { [weak self] result in
                switch result {
                case .success(let reward):
                    self?.reward = reward
                    self?.delegate?.didUpdateEarnRedeemMessageData()
                case .failure(let error):
                    Logger().log(error: error)
                }
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
        semaphore.signal()
    }
}
