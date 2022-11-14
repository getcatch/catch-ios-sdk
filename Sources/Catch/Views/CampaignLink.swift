//
//  CampaignLink.swift
//  Catch
//
//  Created by Lucille Benoit on 10/23/22.
//

import UIKit

public class CampaignLink: BaseWidget {
    internal var flexButton: UIButton { return externalLinkButton }

    // MARK: - Subviews
    private lazy var merchantCard = MerchantRewardCard()
    internal var externalLinkButton: ExternalLinkButton
    private lazy var claimNowLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()

    override var orderedSubviews: [UIView] {
        return [logo, label, merchantCard, claimNowLabel, externalLinkButton]
    }

    private var campaignName: String

    // MARK: - Initializers

    public init(campaignName: String,
                borderStyle: BorderStyle = .roundedRect,
                theme: Theme? = nil) {
        self.campaignName = campaignName
        let insets = UIEdgeInsets(inset: UIConstant.largeSpacing)
        // pill borders will be treated like rounded rect borders for card-based widgets
        let border: BorderStyle = borderStyle == .pill ? .roundedRect : borderStyle
        let config = BaseWidgetConfig(price: 0,
                                      theme: theme,
                                      borderConfig: BorderConfig(insets: insets, style: border))
        self.externalLinkButton = ExternalLinkButton(title: String(), url: nil)
        super.init(config: config)

        setConstraints()
        didUpdateTheme()
        configureClaimNowLabel()
    }

    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func initializeViewModel(config: BaseWidgetConfig) {
        viewModel = CampaignLinkViewModel(campaignName: campaignName, delegate: self)
    }

    private func configureClaimNowLabel() {
        let claimNowText = LocalizedString.claimNowAndStartEarning.localized("10%")
        let style = label.style.filler.withScaledFont(multiplier: 0.875)
        claimNowLabel.attributedText = NSAttributedString(string: claimNowText, style: style)
    }

    override func didUpdateTheme() {
        super.didUpdateTheme()
        let style = NSAttributedStringStyle(font: CatchFont.buttonLabel,
                                            textColor: theme.backgroundColor,
                                            backgroundColor: theme.accentColor)
        externalLinkButton.setStyle(style)
        configureClaimNowLabel()
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

    /**
     Constraints to pin the button to the edges of the parent view.
     */
    private lazy var extendedButtonConstraints: [NSLayoutConstraint] = [
        externalLinkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
        externalLinkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
    ]

    override public func layoutSubviews() {
        layoutFlexButton()
        let offset = CGSize(width: 2.0, height: 2.0)
        merchantCard.addShadow(offset: offset, color: .black, radius: 4, opacity: 0.2)

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
}

extension CampaignLink: CampaignLinkDelegate {
    func updateCardData(amount: Int, expiration: Date?, merchant: Merchant?) {
        DispatchQueue.main.async { [weak self] in
            self?.merchantCard.updateCardData(merchant: merchant, earnedAmount: amount, expiration: expiration)
        }
    }

    func updateClaimNowMessage(rewardsRateString: String) {
        let claimNowText = LocalizedString.claimNowAndStartEarning.localized(rewardsRateString)
        let style = label.style.filler.withScaledFont(multiplier: 0.875)
        claimNowLabel.attributedText = NSAttributedString(string: claimNowText, style: style)
    }

    func updateButtonConfiguration(buttonTitle: String, url: URL?) {
        DispatchQueue.main.async { [weak self] in
            self?.externalLinkButton.updateConfiguration(text: buttonTitle, url: url)
        }
    }
}
