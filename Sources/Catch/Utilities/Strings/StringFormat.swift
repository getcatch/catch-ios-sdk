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
                                  amountString: String,
                                  hasRedeemableCredits: Bool = false) -> String {
        var string: String = ""

        if case .campaignLink = type {
            string = LocalizedString.credit.localized(amountString)
        } else {
            let hasOrPrefix = type == .callout(hasOrPrefix: true)
            string = StringFormat.getEarnRedeemString(
                amount: amountString,
                hasCredits: hasRedeemableCredits,
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
            return isCompact ? "" : LocalizedString.payByBank.localized + " "
        case .campaignLink(let merchantName):
            return " " + LocalizedString.toSpendAtNextTimeYouPayWithCatch
                .localized(merchantName)
        }
    }

    /**
     Creates a localized price string given the integer number of cents.
     */
    static func priceString(from cents: Int) -> String {
        NumberFormatter.currencyFormatter.string(from: NSNumber(value: cents / 100)) ?? String()
    }

    /**
     Creates a percentage string from decimal value between 0 and 1.
     */
    static func percentString(from decimal: Double) -> String {
        return NumberFormatter.percentFormatter.string(from: NSNumber(value: decimal)) ?? String()
    }

}

private extension StringFormat {

    static func getEarnRedeemString(amount: String,
                                    hasCredits: Bool = false,
                                    hasOrPrefix: Bool = false) -> String {

        var stringFormat = hasCredits
        ? LocalizedString.redeem.localized
        : LocalizedString.earnCredit.localized

        if hasOrPrefix {
            stringFormat = stringFormat.lowercased()
        }

        return String(format: stringFormat, amount)
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
