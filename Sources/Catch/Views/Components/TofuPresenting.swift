//
//  TofuPresenting.swift
//  Catch
//
//  Created by Lucille Benoit on 11/22/22.
//

import UIKit

/**
 Protocol enabling a view to present the Tofu modals.
 */
protocol TofuPresenting: UIView {}

extension TofuPresenting {
    func presentTofuModal(rewards: RewardsCalculatorResult, path: TofuPath = .howItWorks) {
        guard let webController = TofuController(price: rewards.price,
                                                 rewardSummary: rewards.summary,
                                                 path: path) else { return }
        webController.modalPresentationStyle = .overFullScreen
        UIApplication.topViewController()?.present(webController, animated: true)
    }
}
