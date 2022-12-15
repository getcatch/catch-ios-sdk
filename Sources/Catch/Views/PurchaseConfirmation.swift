//
//  PurchaseConfirmation.swift
//  Catch
//
//  Created by Lucille Benoit on 10/23/22.
//

import UIKit

public class PurchaseConfirmation: BaseCardWidget {

    // MARK: - Properties

    override var orderedSubviews: [UIView] {
        return [logo, label, merchantCard, externalLinkButton]
    }

    override var widgetType: StyleResolver.WidgetType { return .purchaseConfirmation }

    // MARK: - Initializers

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

        if let merchant = Catch.merchantRepository.getCurrentMerchant() {
            merchantCard.updateCardData(merchant: merchant,
                                        earnedAmount: 0,
                                        expiration: merchant.expirationDate)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViewModel(config: BaseWidgetConfig) {
        viewModel = PurchaseConfirmationViewModel(config: config, delegate: self)
    }

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
