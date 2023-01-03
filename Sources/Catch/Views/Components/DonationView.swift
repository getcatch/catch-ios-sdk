//
//  DonationView.swift
//  
//
//  Created by Lucille Benoit on 12/23/22.
//

import UIKit

class DonationView: UIView {
    let amount: Int
    let merchantName: String
    let recipient: DonationRecipient

    private let margin: CGFloat = UIConstant.largeSpacing
    private let regularTextStyle = TextStyle(font: CatchFont.bodySmall,
                                             textColor: CatchColor.gray6,
                                             lineSpacing: UIConstant.defaultLineSpacing)
    private let boldTextStyle = TextStyle(font: CatchFont.linkSmall,
                                          textColor: CatchColor.gray6,
                                          isUnderlined: true)
    private let titleFont = CatchFont.heading3

    lazy var icon: UIImageView = {
        let image = CatchAssetProvider.image(.donateIcon)?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = CatchColor.purple2
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()

    lazy var titleStack: UIStackView = {
        let stack = UIStackView()

        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(titleLabel)

        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = UIConstant.smallSpacing
        return stack
    }()

    lazy var subtitleLabel: TappableLabel = {
        let label = TappableLabel(attributedStrings: [])
        label.numberOfLines = 0
        return label
    }()

    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(titleStack)
        stack.addArrangedSubview(subtitleLabel)
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = UIConstant.smallMediumSpacing
        configureStackInsets(stack)
        return stack
    }()

    // MARK: - Initializers

    init(amount: Int, merchantName: String, recipient: DonationRecipient) {
        self.amount = amount
        self.merchantName = merchantName
        self.recipient = recipient
        super.init(frame: .zero)

        configureBackground()
        addSubview(stack)
        setConstraints()
        updateTitleText()
        updateSubtitleText()
        subtitleLabel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func configureBackground() {
        layer.masksToBounds = true
        layer.cornerRadius = UIConstant.defaultCornerRadius
        layer.borderWidth = UIConstant.defaultBorderWidth
        layer.borderColor = CatchColor.purple2.cgColor
        backgroundColor = CatchColor.purple
    }

    func updateTitleText() {
        let priceString = StringFormat.priceString(from: amount)
        titleLabel.text = LocalizedString.youDonated.localized(priceString)
        titleLabel.font = titleFont
    }

    func updateSubtitleText() {
        let merchantContributionString = LocalizedString.merchantMatchedYourContribution.localized(merchantName) + " "
        let recipientString = recipient.name
        let thanksString = ". \(LocalizedString.thanksForPitchingIn.localized)"

        let matchedStringConfig = TappableLabelTextConfig(text: merchantContributionString, style: regularTextStyle)
        let recipientStringConfig = TappableLabelTextConfig(text: recipientString, style: boldTextStyle)
        let thanksStringConfig = TappableLabelTextConfig(text: thanksString, style: regularTextStyle)
        subtitleLabel.updateLabelString([matchedStringConfig] + [recipientStringConfig] + [thanksStringConfig])
    }

    private func setConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureStackInsets(_ stack: UIStackView) {
        let insets = UIEdgeInsets(inset: margin)
        stack.layoutMargins = insets
        stack.isLayoutMarginsRelativeArrangement = true
    }
}

extension DonationView: TappableLabelDelegate {
    func didTapLink() {
        if let url = URL(string: recipient.url) {
            UIApplication.shared.open(url)
        }
    }
}
