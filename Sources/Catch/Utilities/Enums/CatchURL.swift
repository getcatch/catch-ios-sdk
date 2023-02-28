//
//  CatchURL.swift
//  
//
//  Created by Lucille Benoit on 10/11/22.
//

import Foundation

enum CatchURL {
    static let getPublicMerchantData = "/api/merchants-svc/merchants/public_keys/%@/public"
    static let getPublicUserData = "/api/transactions-svc/user_devices/%@/user_data"
    static let getEarnedRewards = "/api/transactions-svc/merchants/%@/calculate_earned_rewards/public"
    static let getRewardCampaignByExternalName = "/api/transactions-svc/merchants/%@/reward_campaigns/%@/public"
    static let getDonationCampaign = "/api/transactions-svc/merchants/%@/active_donation_campaign/public"
    static let logoImage = "https://assets.getcatch.com/merchant-assets/%@/card_logo.png"
    static let signIn = "https://app.getcatch.com/u/sign-in"
    static let rewardCampaignLandingPage = "/u/e/%@"
    static let tofuPath = "/t/"
    static let checkoutPath = "/c/"

    static func tofu(_ merchantRepository: MerchantRepositoryInterface) -> URL? {
        guard let merchant = merchantRepository.getCurrentMerchant(),
              let publicKey = merchantRepository.merchantPublicKey,
              let queryItems = try? TofuURLQuery(merchant: merchant,
                                                 publicKey: publicKey).toQueryItems(encodingStrategy: .useDefaultKeys)
        else { return nil }
        return URLComponents(path: CatchURL.tofuPath, queryItems: queryItems).url
    }

    static func directCheckout(checkoutId: String,
                               prefillFields: CheckoutPrefill?,
                               merchantRepository: MerchantRepositoryInterface) -> URL? {
        guard let merchant = merchantRepository.getCurrentMerchant(),
              let publicKey = merchantRepository.merchantPublicKey else { return nil }
        let directCheckoutQuery = DirectCheckoutURLQuery(checkoutId: checkoutId,
                                                         prefill: prefillFields,
                                                         themeConfig: merchant.theme,
                                                         publicKey: publicKey)
        return checkoutURL(fromEncodableObject: directCheckoutQuery)
    }

    static func virtualCardCheckout(orderId: String,
                                    prefillFields: CheckoutPrefill?,
                                    merchantRepository: MerchantRepositoryInterface) -> URL? {
        guard let merchant = merchantRepository.getCurrentMerchant(),
              let publicKey = merchantRepository.merchantPublicKey else { return nil }
        let virtualCardCheckoutQuery = VirtualCardCheckoutURLQuery(orderId: orderId,
                                                                   prefill: prefillFields,
                                                                   themeConfig: merchant.theme,
                                                                   publicKey: publicKey)
        return checkoutURL(fromEncodableObject: virtualCardCheckoutQuery)
    }

    private static func checkoutURL(fromEncodableObject object: Encodable) -> URL? {
        let queryItems = try? object.toQueryItems(encodingStrategy: .useDefaultKeys)
        return URLComponents(path: CatchURL.checkoutPath, queryItems: queryItems).url

    }
}
