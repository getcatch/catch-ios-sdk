//
//  TofuController.swift
//  Catch
//
//  Created by Lucille Benoit on 11/10/22.
//

import Foundation

class TofuController: CatchWebViewController, PostMessageHandler {
    let path: TofuPath
    let price: Int
    let earnedRewardsSummary: EarnedRewardsSummary
    let merchantRepository: MerchantRepositoryInterface

    init?(price: Int,
          rewardSummary: EarnedRewardsSummary,
          path: TofuPath = .howItWorks,
          merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository) {
        self.path = path
        self.price = price
        self.earnedRewardsSummary = rewardSummary
        self.merchantRepository = merchantRepository
        guard let url = CatchURL.tofu(merchantRepository) else { return nil }
        super.init(url: url)
        postMessageHandler = self
    }

    func handlePostMessage(_ postMessage: PostMessageAction) {
        switch postMessage {
        case .tofuReady:
            let sendTofuData: JSScript = .postMessage(action: .tofuOpen, dataObject: tofuOpenData)
            webView.evaluateScript(sendTofuData)
        case .tofuBack:
            dismiss(animated: true)
        default: ()
        }
    }

    private var tofuOpenData: [String: Any] {
        guard let merchant = merchantRepository.getCurrentMerchant() else { return [:] }

        return TofuOpenData(earnedRewards: earnedRewardsSummary,
                            price: price,
                            merchant: merchant,
                            path: path).dict
    }
}
