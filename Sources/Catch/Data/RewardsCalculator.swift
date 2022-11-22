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
    var readyToFetch: Bool { get }
    func getEarnedRewardsSummary() -> EarnedRewardsSummary?
    func fetchCalculatedEarnedReward(price: Int, items: [Item]?, userCohorts: [String]?,
                                     completion: @escaping (Result<RewardsCalculatorResult, Error>) -> Void)
}

class RewardsCalculator: RewardsCalculatorInterface {

    private var earnedRewardsSummary: EarnedRewardsSummary?

    private let userRepository: UserRepositoryInterface
    private let merchantRepository: MerchantRepositoryInterface
    private let rewardsNetworkService: RewardsCalculatorNetworkServiceInterface

    var readyToFetch: Bool {
        return userRepository.didFetchUserData
    }

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

    func fetchCalculatedEarnedReward(price: Int,
                                     items: [Item]?,
                                     userCohorts: [String]?,
                                     completion: @escaping (Result<RewardsCalculatorResult, Error>) -> Void) {

        guard let merchant = merchantRepository.getCurrentMerchant(),
              let publicUserData = userRepository.getCurrentUser() else {
            completion(.failure(NetworkError.requestError(.noPublicUserData)))
            return
        }

        let queryItems = generateQueryParams(price: price, items: items, userCohorts: userCohorts)

        rewardsNetworkService.getCalculateEarnedRewards(merchantId: merchant.merchantId,
                                                        queryItems: queryItems) { [weak self] result in
            switch result {
            case .success(let rewardSummary):
                self?.earnedRewardsSummary = rewardSummary
                if let rewardToDisplay = self?.getPrioritizedReward(
                    rewardSummary: rewardSummary,
                    purchasePrice: price,
                    existingUserRewardAmount: publicUserData.rewardAmount,
                    defaultMerchantRewardRate: merchant.defaultEarnedRewardsRate
                ) {
                    let prioritizedRewardSummary = RewardsCalculatorResult(price: price,
                                                                           prioritizedReward: rewardToDisplay,
                                                                           summary: rewardSummary)
                    completion(.success(prioritizedRewardSummary))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private Helpers

    private func getPrioritizedReward(rewardSummary: EarnedRewardsSummary,
                                      purchasePrice: Int,
                                      existingUserRewardAmount: Int,
                                      defaultMerchantRewardRate: Double) -> Reward {
        // Take the larger of the rewards rates between
        // the default merchant rate and the rate returned in the rewards summary
        let effectiveRewardRate = max(defaultMerchantRewardRate, rewardSummary.percentageRewardRate)

        // If the purchase price is less than or equal to 0, fallback on the rewards rate.
        guard purchasePrice > 0 else {
            return .percentRate(effectiveRewardRate)
        }

        let signUpDiscountAmount = rewardSummary.signUpDiscountAmount
        if signUpDiscountAmount > 0 {
            // If the user is earning a sign up discount, use that and append any other existing rewards
            let savedAmount = signUpDiscountAmount + existingUserRewardAmount
            return .earnedCredits(min(savedAmount, purchasePrice))
        } else if existingUserRewardAmount > 0 {
            // If the user has rewards to redeem, use that instead of the earned amount
            return .redeemableCredits(min(existingUserRewardAmount, purchasePrice))
        } else if let earnedRewardsTotal = rewardSummary.earnedRewardsTotal, earnedRewardsTotal > 0 {
            // Return the earned rewards only if earned rewards > 0.
            return .earnedCredits(earnedRewardsTotal)
        }
        // Otherwise fallback to the rewards rate
        return .percentRate(effectiveRewardRate)
    }

    private func generateQueryParams(price: Int, items: [Item]?, userCohorts: [String]?) -> [URLQueryItem] {
        let publicUserData = userRepository.getCurrentUser() ?? PublicUserData.noData
        let amount = max(price - publicUserData.rewardAmount, 0)

        var calculateEarnedRewardsQuery = CalculateEarnedRewardsQuery(
            amountEligibleForEarnedRewards: amount,
            isNewCatchUser: publicUserData.firstPurchaseBonusEligibility
        )

        // Convert items and userCohorts to comma separated strings
        if let items = items, !items.isEmpty {
            calculateEarnedRewardsQuery.items = items.map { $0.queryString }.joined(separator: ",")
        }

        if let userCohorts = userCohorts, !userCohorts.isEmpty {
            calculateEarnedRewardsQuery.userCohorts = userCohorts.joined(separator: ",")
        }

        let queryItems = try? calculateEarnedRewardsQuery.toQueryItems()

        return queryItems ?? []

    }
}
