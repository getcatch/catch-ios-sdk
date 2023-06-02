//
//  CatchURL.swift
//  
//
//  Created by Lucille Benoit on 10/11/22.
//

import Foundation

enum CatchURL {
    static let getPublicMerchantData = "/api/merchants-svc/merchants/public_keys/%@/public"
    static let getEarnedRewards = "/api/transactions-svc/merchants/%@/calculate_earned_rewards/public"
    static let getWidgetContent = "/api/transactions-svc/merchants/%@/widget_content/public"
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
        return checkoutURL(fromCheckoutQuery: directCheckoutQuery)
    }

    static func virtualCardCheckout(prefillFields: CheckoutPrefill?,
                                    merchantRepository: MerchantRepositoryInterface) -> URL? {
        guard let merchant = merchantRepository.getCurrentMerchant(),
              let publicKey = merchantRepository.merchantPublicKey else { return nil }
        let virtualCardCheckoutQuery = VirtualCardCheckoutURLQuery(prefill: prefillFields,
                                                                   themeConfig: merchant.theme,
                                                                   publicKey: publicKey)
        return checkoutURL(fromCheckoutQuery: virtualCardCheckoutQuery)
    }

    private static func checkoutURL(fromCheckoutQuery object: CheckoutURLQuery) -> URL? {
        let queryString = object.generateQueryString()
        guard var urlString = URLComponents(path: CatchURL.checkoutPath).url?.absoluteString else {
            return nil
        }

        if let queryStr = object.generateQueryString() {
            urlString += queryStr
        }
        return URL(string: urlString)
    }
}
