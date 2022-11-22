//
//  CampaignLink.swift
//  Catch
//
//  Created by Lucille Benoit on 10/23/22.
//

import UIKit

public class CampaignLink: BaseCardWidget {

    // MARK: - Subviews
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
        super.init(theme: theme, borderStyle: borderStyle)
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
        configureClaimNowLabel()
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
