//
//  PurchaseConfirmation.swift
//  Catch
//
//  Created by Lucille Benoit on 10/23/22.
//

import UIKit

public class PurchaseConfirmation: BaseWidget {

    // MARK: - Subviews
    private lazy var merchantCard = MerchantRewardCard()
    internal var flexButton: UIButton {
        return externalLinkButton
    }
    private var externalLinkButton: ExternalLinkButton

    // MARK: - Properties

    override var orderedSubviews: [UIView] {
        return [logo, label, merchantCard, externalLinkButton]
    }

    /**
     Constraints to pin the button to the edges of the parent view.
     */
    private lazy var extendedButtonConstraints: [NSLayoutConstraint] = [
        externalLinkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
        externalLinkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
    ]

    // MARK: - Initializers

    public init(earned: Int,
                borderStyle: BorderStyle = .roundedRect,
                theme: Theme? = nil,
                donation: Int? = nil) {
        // pill borders will be treated like rounded rect borders for the purchase confirmation widget
        let border: BorderStyle = borderStyle == .pill ? .roundedRect : borderStyle
        let insets = UIEdgeInsets(inset: UIConstant.largeSpacing)

        let config = BaseWidgetConfig(price: earned,
                                      theme: theme,
                                      borderConfig: BorderConfig(insets: insets, style: border))

        self.externalLinkButton = ExternalLinkButton(title: LocalizedString.viewYourCredit.localized,
                                                     url: URL(string: CatchURL.signIn))

        super.init(config: config)

        externalLinkButton.translatesAutoresizingMaskIntoConstraints = false
        setConstraints()
        didUpdateTheme()
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

    override func didUpdateTheme() {
        super.didUpdateTheme()
        let style = NSAttributedStringStyle(font: CatchFont.buttonLabel,
                                            textColor: theme.backgroundColor,
                                            backgroundColor: theme.accentColor)

        externalLinkButton.setStyle(style)
    }

    override func configureStack() {
        stack.spacing = UIConstant.largeSpacing
        stack.setCustomSpacing(UIConstant.extraLargeSpacing, after: merchantCard)
        stack.axis = .vertical
        stack.alignment = .leading
    }

    override func createBenefitTextStyle() -> EarnRedeemLabel.Style {
        let earnStyle = NSAttributedStringStyle(font: CatchFont.linkLarge,
                                                textColor: theme.accentColor,
                                                isTappable: false)
        let redeemStyle = NSAttributedStringStyle(font: CatchFont.linkLarge,
                                                  textColor: theme.secondaryAccentColor,
                                                  isTappable: false)
        let fillerTextStyle = NSAttributedStringStyle(font: CatchFont.bodyLarge,
                                                      textColor: theme.foregroundColor)
        return EarnRedeemLabel.Style(filler: fillerTextStyle, earn: earnStyle, redeem: redeemStyle)
    }

    override var additionalConstraints: [NSLayoutConstraint] {
        return [logo.heightAnchor.constraint(equalToConstant: UIConstant.largeLogoHeight)]
    }

    override public func layoutSubviews() {
        layoutFlexButton()
        let offset = UIConstant.merchantCardShadowOffset
        let radius = UIConstant.merchantCardShadowRadius
        let opacity = UIConstant.merchantCardShadowOpacity
        merchantCard.addShadow(offset: offset, color: .black, radius: radius, opacity: opacity)
        super.layoutSubviews()
    }

    /**
     Updates the layout of the external link button based on the width of the view.
     For views wider that the max button width, the button hugs its content.
     Otherwise, the button fills the available space.
     */
    func layoutFlexButton() {
        if frame.width > UIConstant.maxExternalLinkButtonWidth {
            NSLayoutConstraint.deactivate(extendedButtonConstraints)
        } else {
            NSLayoutConstraint.activate(extendedButtonConstraints)
        }
        layoutIfNeeded()
    }

    override public func setPrice(_ price: Int) {
        viewModel?.updatePrice(price)
        merchantCard.updateEarnedAmount(earnedAmount: price)
    }
}

extension PurchaseConfirmation: PurchaseConfirmationViewModelDelegate {
    func updateCardData(amount: Int, expiration: Date?, merchant: Merchant?) {
        DispatchQueue.main.async { [weak self] in
            self?.merchantCard.updateCardData(merchant: merchant, earnedAmount: amount, expiration: expiration)
        }
    }
}
