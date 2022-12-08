//
//  EarnRedeemLabelType.swift
//  
//
//  Created by Lucille Benoit on 10/11/22.
//

import Foundation

enum EarnRedeemLabelType: Equatable {
    case callout(hasOrPrefix: Bool)
    case expressCheckoutCallout
    case paymentMethod(isCompact: Bool)
    case purchaseConfirmation(merchantName: String, amountEarned: Int)
    case campaignLink(merchantName: String)

    // If widget is the non-compact configuration of PaymentMethod,
    // the filler string should be at the beginning of the string.
    var prependFillerString: Bool {
        return self == .paymentMethod(isCompact: false)
    }

    // If widget is compact configuration of PaymentMethod,
    // hide the filler string entirely
    var hideFillerString: Bool {
        return self == .paymentMethod(isCompact: true)
    }

    var benefitTextIsUnderlined: Bool {
        switch self {
        case .callout, .expressCheckoutCallout, .paymentMethod:
            return true
        default:
            return false
        }
    }
}
