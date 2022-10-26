//
//  Reward.swift
//  Catch
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

enum Reward {
    case earnedCredits(Int)
    case redeemableCredits(Int)
    case percentRate(Double)

    func toString() -> String {
        switch self {
        case .earnedCredits(let cents):
            return StringFormat.priceString(from: cents)
        case .redeemableCredits(let cents):
            return StringFormat.priceString(from: cents)
        case .percentRate(let double):
            return StringFormat.percentString(from: double)
        }
    }

    var hasRedeemableCredits: Bool {
        switch self {
        case .redeemableCredits:
            return true
        default:
            return false
        }
    }
}
