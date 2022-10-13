//
//  LocalizedString.swift
//  Catch
//
//  Created by Lucille Benoit on 10/10/22.
//

import Foundation

enum LocalizedString: String {
    // Tooltip Strings
    case sorryCatchCantBeUsed = "sorry_catch_cant_be_used"
    case learnMoreAboutCatch = "learn_more_about_catch"

    // Earn Redeem message strings
    case payByBank = "pay_by_bank"
    case or = "or"
    case redeem = "redeem"
    case earnCredit = "earn_credit"
    case byPayingWith = "by_paying_with"
    case with = "with"

    // Express Checkout Callout strings
    case findUsAt = "find_us_at"
    case paymentStep = "payment_step"

    // Purchase Confirmation Strings
    case youEarnedCredit = "you_earned_credit"
    case toSpendAt = "to_spend_at"
    case viewYourCredit = "view_your_credit"

    // Campaign Link Strings
    case youEarned = "you_earned"
    case credit = "credit"
    case toSpendAtNextTimeYouPayWithCatch = "to_spend_at_next_time_you_pay_with_catch"
    case claimStoreCredit = "claim_store_credit"

    var localized: String {
        return NSLocalizedString(self.rawValue, bundle: CatchResources.resourceBundle, comment: "\(self)_comment")
    }

    func localized(_ args: CVarArg...) -> String {
      return String(format: localized, args)
    }
}
