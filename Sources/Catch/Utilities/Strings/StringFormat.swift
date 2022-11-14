//
//  StringFormat.swift
//  Catch
//
//  Created by Lucille Benoit on 10/13/22.
//

import Foundation

enum StringFormat {
    /** Creates string signifying amount to be earned or redeemed
     ex. "Earn $20 credit", "Redeem $20" or "or earn 10% credit"
     based on widget type, amount and whether user has redeemable credits */
    static func getEarnRedeemText(type: EarnRedeemLabelType,
                                  reward: Reward) -> String {
        var string: String = ""
        switch type {
        case .purchaseConfirmation, .campaignLink:
            string = LocalizedString.youEarnedCredit.localized(reward.toString())
        default:
            let hasOrPrefix = type == .callout(hasOrPrefix: true)
            string = StringFormat.getEarnRedeemString(
                reward: reward,
                hasOrPrefix: hasOrPrefix)
        }

        return string
    }

    static func getEarnRedeemFillerText(type: EarnRedeemLabelType) -> String {
        switch type {
        case .callout:
            return " " + LocalizedString.byPayingWith.localized
        case .expressCheckoutCallout:
            return " " + LocalizedString.with.localized
        case .paymentMethod(let isCompact):
            return isCompact ? "" : LocalizedString.payByBank.localized.nonBreaking + " "
        case .purchaseConfirmation(let merchantName, _):
            let toSpend = LocalizedString.toSpend.localized
            let atMerchant = LocalizedString.atMerchant.localized(merchantName).nonBreaking
            return String(format: " %@ %@", toSpend, atMerchant)
        case .campaignLink(let merchantName):
            return " " + LocalizedString.toSpendAtNextTimeYouPayWithCatch
                .localized(merchantName)
        }
    }

    /**
     Creates a localized price string given the integer number of cents.
     */
    static func priceString(from cents: Int) -> String {
        let priceInDollars = Double(cents) / 100
        return NumberFormatter.currencyFormatter.string(from: NSNumber(value: priceInDollars)) ?? String()
    }

    /**
     Creates a percentage string from decimal value between 0 and 1.
     */
    static func percentString(from decimal: Double) -> String {
        return NumberFormatter.percentFormatter.string(from: NSNumber(value: decimal)) ?? String()
    }

    static func dateString(from date: Date) -> String {
        return DateFormatter.expirationDate.string(from: date)
    }

}

private extension StringFormat {

    static func getEarnRedeemString(reward: Reward,
                                    hasOrPrefix: Bool = false) -> String {

        var stringFormat = reward.hasRedeemableCredits
        ? LocalizedString.redeem.localized
        : LocalizedString.earnCredit.localized

        if hasOrPrefix {
            stringFormat = stringFormat.lowercased()
        }

        return String(format: stringFormat, reward.toString())
    }
}

extension NumberFormatter {
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }

    static var percentFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 3
        formatter.maximumFractionDigits = 0
        return formatter
    }
}

extension DateFormatter {
    static var expirationDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        formatter.timeZone = TimeZone.current
        return formatter
    }
}
