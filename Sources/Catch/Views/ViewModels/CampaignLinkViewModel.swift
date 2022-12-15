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
    func hideWidget()
}

internal class CampaignLinkViewModel: BaseCardViewModel {

    // MARK: Properties
    weak var delegate: CampaignLinkDelegate?

    internal var textLabelType: EarnRedeemLabelType {
        return .campaignLink(merchantName: merchantName)
    }

    internal var rewardsRateString: String {
        var rate = Constant.defaultRewardsRate
        if let merchant = merchant {
            rate = merchant.defaultEarnedRewardsRate
        }
        return StringFormat.percentString(from: rate)
    }

    internal var campaignLinkURL: URL?

    internal var amount: Int {
        return rewardCampaign?.totalAmount ?? 0
    }

    private var rewardCampaign: RewardCampaign? {
        didSet {
            updateRewardViews()
        }
    }

    private let rewardCampaignService: RewardCampaignNetworkServiceInterface

    // MARK: - Initializer

    required init(campaignName: String,
                  delegate: CampaignLinkDelegate,
                  merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository,
                  rewardsService: RewardCampaignNetworkServiceInterface = RewardCampaignNetworkService()) {
        self.delegate = delegate
        self.rewardCampaignService = rewardsService
        super.init()
        fetchCampaignWithExternalName(campaignName)
    }

    // MARK: - Functions

    /**
     Fetches an active reward campaign with the given external name for the current merchant.
     */
    private func fetchCampaignWithExternalName(_ name: String) {
        guard let publicKey = merchantPublicKey else {
            let error = NetworkError.requestError(.invalidPublicKey(String()))
            Logger.log(error: error)
            delegate?.hideWidget()
            return
        }
        rewardCampaignService.fetchRewardCampaign(named: name, publicKey: publicKey) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let campaign):
                self.rewardCampaign = campaign
                self.configureCampaignURL(from: campaign)
            case .failure(let error):
                Logger.log(error: error)
                self.delegate?.hideWidget()
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
            delegate.updateEarnRedeemMessage(reward: reward, type: self.textLabelType)
            delegate.updateCardData(amount: self.amount,
                                    expiration: self.rewardCampaign?.rewardsExpiration,
                                    merchant: self.merchant)
            let buttonTitle = LocalizedString.claimStoreCredit.localized(reward.toString())
            delegate.updateButtonConfiguration(buttonTitle: buttonTitle, url: self.campaignLinkURL)
        }
    }

    internal func updateMerchantViews() {
        delegate?.updateClaimNowMessage(rewardsRateString: rewardsRateString)
        delegate?.updateCardData(amount: amount,
                                 expiration: rewardCampaign?.rewardsExpiration,
                                 merchant: merchant)
    }
}
