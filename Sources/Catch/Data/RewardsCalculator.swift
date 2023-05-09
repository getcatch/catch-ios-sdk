//
//  RewardsCalculator.swift
//  Catch
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

struct RewardsCalculatorResult {
    let price: Int
    let prioritizedReward: Reward
    let summary: EarnedRewardsSummary
}

protocol RewardsCalculatorInterface {
    func getWidgetContentPublicUserData() -> WidgetContentPublicUserData?
    func getEarnedRewardsSummary() -> EarnedRewardsSummary?
    func fetchCalculatedEarnedReward(price: Int, items: [Item]?, userCohorts: [String]?,
                                     completion: @escaping (Result<RewardsCalculatorResult, Error>) -> Void)
}

class RewardsCalculator: RewardsCalculatorInterface {

    private var earnedRewardsSummary: EarnedRewardsSummary?

    private let userRepository: UserRepositoryInterface
    private let merchantRepository: MerchantRepositoryInterface
    private let rewardsNetworkService: RewardsCalculatorNetworkServiceInterface

    // MARK: - Initializer

    init(userRepository: UserRepositoryInterface,
         merchantRepository: MerchantRepositoryInterface,
         rewardsNetworkService: RewardsCalculatorNetworkServiceInterface = RewardsCalculatorNetworkService()) {
        self.userRepository = userRepository
        self.merchantRepository = merchantRepository
        self.rewardsNetworkService = rewardsNetworkService
    }

    // MARK: - Public Functions

    func getEarnedRewardsSummary() -> EarnedRewardsSummary? {
        return earnedRewardsSummary
    }

    func getWidgetContentPublicUserData() -> WidgetContentPublicUserData? {
        return userRepository.getCurrentUser()
    }

    func fetchCalculatedEarnedReward(price: Int,
                                     items: [Item]?,
                                     userCohorts: [String]?,
                                     completion: @escaping (Result<RewardsCalculatorResult, Error>) -> Void) {
        guard let merchant = merchantRepository.getCurrentMerchant() else {
            completion(.failure(NetworkError.requestError(.noMerchant)))
            return
        }
        let requestData = CalculateEarnedRewardRequestData(price: price, items: items, userCohorts: userCohorts)

        conditionallyFetchRewardsSummary(merchant: merchant,
                                         requestData: requestData) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let rewardSummary):
                    self.earnedRewardsSummary = rewardSummary
                    guard let userData = self.getWidgetContentPublicUserData(),
                          let rewardSummary = rewardSummary else {
                        completion(.failure(NetworkError.requestError(.noPublicUserData)))
                        return
                    }
                    let displayableResult = self.calculateRewardResult(rewardSummary: rewardSummary,
                                                                        price: price,
                                                                        publicUserData: userData,
                                                                        merchant: merchant)
                    completion(.success(displayableResult))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    // MARK: - Private Helpers

    /**
     Fetches the potential earned rewards summary through the `/widget_content` endpoint
     if no public user data is cached. All subsequent calls go through the `/calculate` endpoint instead.
     */
    private func conditionallyFetchRewardsSummary(
        merchant: Merchant,
        requestData: CalculateEarnedRewardRequestData,
        completion: @escaping (Result<EarnedRewardsSummary?, Error>) -> Void
    ) {
        if let userData = userRepository.getCurrentUser() {
            // If we have public user data already cached, call the `/calculate_earned_rewards` endpoint.
            fetchCalculatedEarnedRewards(merchant: merchant,
                                         publicUserData: userData,
                                         requestData: requestData,
                                         completion: completion)
        } else {
            // If no public user data is cached, we need to call the `/widget_content` endpoint.
            fetchWidgetContent(merchant: merchant,
                               requestData: requestData,
                               completion: completion)
        }
    }

    /**
     Fetches the calculated earned rewards through the `/widget_content` endpoint.
     Caches the public user data and available rewards from the result.
     */
    private func fetchWidgetContent(merchant: Merchant,
                                    requestData: CalculateEarnedRewardRequestData,
                                    completion: @escaping (Result<EarnedRewardsSummary?, Error>) -> Void) {
        let queryItems = requestData.generateWidgetContentQueryParams(
            deviceToken: userRepository.getDeviceToken(),
            enableConfigurableRewards: merchant.enableConfigurableRewards
        )
        rewardsNetworkService.getWidgetContent(merchantID: merchant.merchantId,
                                               queryItems: queryItems) { [weak self] result in
            switch result {
                case .success(let widgetContent):
                    let userData = widgetContent.publicUserData
                    self?.userRepository.saveUserData(userData)
                    // If merchant doesn't use configurable rewards, generate those locally because
                    // the endpoint will not return the earned rewards
                    if !merchant.enableConfigurableRewards {
                        let locallyGeneratedRewards = merchant.generateCalculatedRewards(
                            price: requestData.price,
                            userRewardAmount: userData.rewardAmount ?? 0,
                            firstPurchaseBonusEligibility: userData.firstPurchaseBonusEligibility)
                        completion(.success(locallyGeneratedRewards))
                    } else {
                        completion(.success(widgetContent.earnedRewards))
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }

    /**
     Calculates the earned rewards locally if the merchant doesn't use configurable rewards.
     Otherwise, fetches the calculated earned rewards through the `calculate_earned_rewards` endpoint.
     */
    private func fetchCalculatedEarnedRewards(merchant: Merchant,
                                              publicUserData: WidgetContentPublicUserData,
                                              requestData: CalculateEarnedRewardRequestData,
                                              completion: @escaping (Result<EarnedRewardsSummary?, Error>) -> Void) {
        guard merchant.enableConfigurableRewards else {
            // If merchant doesn't use configurable rewards, generate the default EarnedRewardsSummary locally.
            let locallyGeneratedRewards = merchant.generateCalculatedRewards(
                price: requestData.price,
                userRewardAmount: publicUserData.rewardAmount ?? 0,
                firstPurchaseBonusEligibility: publicUserData.firstPurchaseBonusEligibility)
            completion(.success(locallyGeneratedRewards))
            return
        }

        // Hit the calculate earned rewards endpoint if configurable rewards are used.
        let queryItems = requestData.generateQueryParams(publicUserData: publicUserData)
        rewardsNetworkService.getCalculateEarnedRewards(merchantId: merchant.merchantId,
                                                        queryItems: queryItems) { result in
            switch result {
            case .success(let rewardSummary):
                completion(.success(rewardSummary))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func calculateRewardResult(rewardSummary: EarnedRewardsSummary,
                                       price: Int,
                                       publicUserData: WidgetContentPublicUserData,
                                       merchant: Merchant) -> RewardsCalculatorResult {
        let rewardToDisplay = getPrioritizedReward(
            rewardSummary: rewardSummary,
            purchasePrice: price,
            existingUserRewardAmount: publicUserData.rewardAmount,
            defaultMerchantRewardRate: merchant.defaultEarnedRewardsRate
        )

        return RewardsCalculatorResult(price: price, prioritizedReward: rewardToDisplay, summary: rewardSummary)
    }

    private func getPrioritizedReward(rewardSummary: EarnedRewardsSummary,
                                      purchasePrice: Int,
                                      existingUserRewardAmount: Int?,
                                      defaultMerchantRewardRate: Double) -> Reward {
        // Take the larger of the rewards rates between
        // the default merchant rate and the rate returned in the rewards summary
        let effectiveRewardRate = max(defaultMerchantRewardRate, rewardSummary.percentageRewardRate)

        // If the purchase price is less than or equal to 0, fallback on the rewards rate.
        guard purchasePrice > 0 else {
            return .percentRate(effectiveRewardRate)
        }

        let signUpDiscountAmount = rewardSummary.signUpDiscountAmount
        let userRewardAmount = existingUserRewardAmount ?? 0
        if signUpDiscountAmount > 0 {
            // If the user is earning a sign up discount, use that and append any other existing rewards
            let savedAmount = signUpDiscountAmount + userRewardAmount
            return .earnedCredits(min(savedAmount, purchasePrice))
        } else if userRewardAmount > 0 {
            // If the user has rewards to redeem, use that instead of the earned amount
            return .redeemableCredits(min(userRewardAmount, purchasePrice))
        } else if let earnedRewardsTotal = rewardSummary.earnedRewardsTotal, earnedRewardsTotal > 0 {
            // Return the earned rewards only if earned rewards > 0.
            return .earnedCredits(earnedRewardsTotal)
        }
        // Otherwise fallback to the rewards rate
        return .percentRate(effectiveRewardRate)
    }
}
