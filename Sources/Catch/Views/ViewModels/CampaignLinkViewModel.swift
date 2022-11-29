//
//  CampaignLinkViewModel.swift
//  Catch
//
//  Created by Lucille Benoit on 11/4/22.
//

import Foundation

protocol CampaignLinkDelegate: AnyObject {
    func updateCardData(amount: Int, expiration: Date?, merchant: Merchant?)
    func updateEarnRedeemMessage(reward: Reward, type: EarnRedeemLabelType)
    func updateClaimNowMessage(rewardsRateString: String)
    func updateButtonConfiguration(buttonTitle: String, url: URL?)
}

internal class CampaignLinkViewModel: BaseWidgetViewModelInterface, MerchantSubscribing {

    // MARK: Properties
    weak var delegate: CampaignLinkDelegate?

    internal var earnRedeemLabelType: EarnRedeemLabelType {
        return .campaignLink(merchantName: merchantName)
    }

    internal var rewardsRateString: String {
        var rate = Constant.defaultRewardsRate
        if let merchant = merchantRepository.getCurrentMerchant() {
            rate = merchant.defaultEarnedRewardsRate
        }
        return StringFormat.percentString(from: rate)
    }

    internal var campaignLinkURL: URL?

    private var amount: Int {
        return rewardCampaign?.totalAmount ?? 0
    }

    private var rewardCampaign: RewardCampaign? {
        didSet {
            updateRewardViews()
        }
    }

    private var merchantName: String {
        let merchant = merchantRepository.getCurrentMerchant()
        return merchant?.name ?? LocalizedString.thisStore.localized
    }

    private let merchantRepository: MerchantRepositoryInterface
    private let rewardCampaignService: RewardCampaignNetworkServiceInterface

    // MARK: - Initializer

    required init(campaignName: String,
                  delegate: CampaignLinkDelegate,
                  merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository,
                  rewardsService: RewardCampaignNetworkServiceInterface = RewardCampaignNetworkService()) {
        self.delegate = delegate
        self.merchantRepository = merchantRepository
        self.rewardCampaignService = rewardsService
        subscribeToMerchantUpdates()
        fetchCampaignWithExternalName(campaignName)
    }

    // MARK: - Functions
    func updatePrice(_ price: Int) { }

    /**
     Fetches an active reward campaign with the given external name for the current merchant.
     */
    private func fetchCampaignWithExternalName(_ name: String) {
        guard let publicKey = merchantRepository.merchantPublicKey else {
            let error = NetworkError.requestError(.invalidPublicKey(String()))
            Logger().log(error: error)
            return
        }
        rewardCampaignService.fetchRewardCampaign(named: name, publicKey: publicKey) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let campaign):
                self.rewardCampaign = campaign
                self.configureCampaignURL(from: campaign)
            case .failure(let error):
                Logger().log(error: error)
            }
        }
    }

    /**
     Generates the reward campaign destination url.
     */
    private func configureCampaignURL(from campaign: RewardCampaign) {
        let components = URLComponents(path: campaign.campaignURLPath)
        campaignLinkURL = components.url
    }

    /**
     Updates the views which are dependant on reward campaign data.
     */
    private func updateRewardViews() {
        // Ensures that any view updates are handled on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let delegate = self.delegate else { return }
            let reward: Reward = .earnedCredits(self.amount)
            delegate.updateEarnRedeemMessage(reward: reward, type: self.earnRedeemLabelType)
            delegate.updateCardData(amount: self.amount,
                                    expiration: self.rewardCampaign?.rewardsExpiration,
                                    merchant: self.merchantRepository.getCurrentMerchant())
            let buttonTitle = LocalizedString.claimStoreCredit.localized(reward.toString())
            delegate.updateButtonConfiguration(buttonTitle: buttonTitle, url: self.campaignLinkURL)
        }
    }

    /**
     Updates the views which are dependant on merchant data.
     */
    internal func handleMerchantNotification(merchant: Merchant) {
        // Ensures that any view updates are handled on the main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let delegate = self.delegate else { return }
            delegate.updateClaimNowMessage(rewardsRateString: self.rewardsRateString)
            delegate.updateCardData(amount: self.amount,
                                    expiration: self.rewardCampaign?.rewardsExpiration,
                                    merchant: merchant)
        }
    }

    /**
     Unsubscribes from merchant update notifications.
     */
    deinit {
        unsubscribeFromMerchantUpdates()
    }
}
