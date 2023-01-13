//
//  PurchaseConfirmation.swift
//  Catch
//
//  Created by Lucille Benoit on 10/23/22.
//

import UIKit

/**
 The PurchaseConfirmation widget is designed to be used on the merchant's order
 confirmation page if Catch was used as a payment method.

 The widget includes information about how much credit the consumer just earned
 through their purchase and contains a link which directs the consumer to their account
 page on Catch's website.
 */
public class PurchaseConfirmation: _BaseCardWidget {

    // MARK: - Properties
    var donation: Int

    private lazy var donationView: DonationView? = {
        guard donation > 0,
            let purchaseConfirmationViewModel = viewModel as? PurchaseConfirmationViewModel,
            let recipient = purchaseConfirmationViewModel.merchant?.donationRecipient else { return nil }
        return DonationView(amount: donation,
                            merchantName: purchaseConfirmationViewModel.merchantName,
                            recipient: recipient)
    }()

    override var orderedSubviews: [UIView] {
        var views = [logo, label, merchantCard, externalLinkButton]
        if let donationView = donationView {
            views.append(donationView)
        }
        return views
    }

    override var widgetType: StyleResolver.WidgetType { return .purchaseConfirmation }

    // MARK: - Initializers

    /**
     Initializes a ``PurchaseConfirmation`` widget.
     - Parameter earned: The amount in cents that that the consumer earned in credit based on their purchase.
     - Parameter borderStyle: The ``BorderStyle`` that the widget renders.
     Defaults to the ``BorderStyle/roundedRect`` style.
     - Parameter theme: The Catch color ``Theme``. If no theme is set, the default
     ``Theme/lightColor`` theme will be used.
     - Parameter styleOverrides: Style overrides which can be used to override the theme's default
     appearance (ex. fonts and colors).
     - Parameter donation: The amount of cents that the consumer is donating. Not used if the merchant
     doesn't have donations enabled.
     */
    public init(earned: Int,
                borderStyle: BorderStyle = .roundedRect,
                theme: Theme? = nil,
                styleOverrides: ActionWidgetStyle? = nil,
                donation: Int? = nil) {
        self.donation = donation ?? 0
        super.init(initialAmount: earned,
                   buttonTitle: LocalizedString.viewYourCredit.localized,
                   buttonURL: URL(string: CatchURL.signIn),
                   theme: theme,
                   styleOverrides: styleOverrides,
                   borderStyle: borderStyle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViewModel(config: BaseWidgetConfig) {
        viewModel = PurchaseConfirmationViewModel(config: config, delegate: self)
    }

    /**
     Sets the amount in credit that the consumer just earned through their purchase.
     - Parameter earned: The amount in cents that that the consumer earned.
     */
    public func setEarnedAmount(_ amount: Int) {
        if let purchaseViewModel = viewModel as? PurchaseConfirmationViewModel {
            purchaseViewModel.updateEarnedAmount(amount)
        }
        merchantCard.updateEarnedAmount(earnedAmount: amount)
    }
}

extension PurchaseConfirmation: PurchaseConfirmationViewModelDelegate {
    func updateCardData(amount: Int, expiration: Date?, merchant: Merchant?) {
        DispatchQueue.main.async { [weak self] in
            self?.merchantCard.updateCardData(merchant: merchant, earnedAmount: amount, expiration: expiration)
        }
    }
}
