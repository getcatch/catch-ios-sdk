//
//  PurchaseConfirmation.swift
//  Catch
//
//  Created by Lucille Benoit on 10/23/22.
//

import UIKit

/**
 The PurchaseConfirmation widget is designed to be used on the merchant's order
 confirmation page if Catch was used as a payment method. The widget includes information
 about how much credit the consumer just earned through their purchase and contains a link
 which directs the consumer to their account page on Catch's website.
 */
public class PurchaseConfirmation: BaseCardWidget {

    // MARK: - Properties

    override var orderedSubviews: [UIView] {
        return [logo, label, merchantCard, externalLinkButton]
    }

    override var widgetType: StyleResolver.WidgetType { return .purchaseConfirmation }

    // MARK: - Initializers

    /**
     Initializes a ``PurchaseConfirmation`` widget.
     - Parameter earned: The amount in cents that that the consumer earned in credit based on their purchase.
     - Parameter borderStyle: The style of border the widget renders. Defaults to the rounded rect border style.
     See ``BorderStyle`` for all border style options.
     - Parameter theme: The Catch color theme. If no theme is set, the default "light-color" theme will be used.
     See ``Theme`` for all theme options.
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
