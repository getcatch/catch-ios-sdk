//
//  MerchantRewardCard.swift
//  Catch
//
//  Created by Lucille Benoit on 10/11/22.
//

import UIKit

class MerchantRewardCard: UIView, Skeletonizable {
    // MARK: - Subviews
    var backgroundImageView: RemoteImageView = RemoteImageView(frame: .zero)
    var merchantLogoView: RemoteImageView = RemoteImageView(frame: .zero)
    var amountLabel: UILabel = UILabel(frame: .zero)
    var expirationLabel: UILabel = UILabel(frame: .zero)

    // MARK: - Private configuration properties
    private var merchantLogoImageUrl = String()
    private var cardFontColor = String()
    private var cardBackgroundImageUrl: String?
    private var cardBackgroundColor = String()
    private var amountString: String? {
        didSet {
            amountLabel.text = amountString
        }
    }
    private var expirationString: String?
    private var padding: CGFloat = UIConstant.largeSpacing

    private var cardWidth: CGFloat {
        padding * UIConstant.merchantCardWidthMultiplier
    }

    private var cardHeight: CGFloat {
        cardWidth * UIConstant.merchantCardAspectRatio
    }

    private var merchantLogoWidth: CGFloat {
        padding * UIConstant.merchantLogoWidthMultiplier
    }

    internal var isLoading: Bool = false {
        didSet {
            if isLoading {
                showSkeleton()
            } else {
                hideSkeleton()
            }
        }
    }

    // MARK: - Initializer
    init() {
        super.init(frame: .zero)
        addSubviews()
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Configuration
    /**
     Updates the data for the merchant card component using a merchant.
     - Parameter merchant: The merchant used to populate the card info.
     The card will end loading once the merchant is populated.
     - Parameter earnedAmount: The integer number of cents earned for this reward.
     - Parameter expiration: The expiration date to display.
     */
    internal func updateCardData(merchant: Merchant?, earnedAmount: Int, expiration: Date?) {
        if let merchant = merchant {
            self.merchantLogoImageUrl = String(format: CatchURL.logoImage, merchant.merchantId)
            self.cardFontColor = merchant.cardFontColor
            self.cardBackgroundImageUrl = merchant.cardBackgroundImageUrl
            self.cardBackgroundColor = merchant.cardBackgroundColor
            // only hides the loading view once merchant data has loaded
            isLoading = false
        }

        // Hide the amount if it is a negative value
        self.amountString = earnedAmount < 0 ? String() : StringFormat.priceString(from: earnedAmount)

        var expirationString = String()
        if let expiration = expiration {
            let dateAsString = StringFormat.dateString(from: expiration)
            expirationString = LocalizedString.expiration.localized(dateAsString)
        }
        self.expirationString = expirationString
        configureSubviews()
    }

    internal func updateEarnedAmount(earnedAmount: Int) {
        self.amountString = StringFormat.priceString(from: earnedAmount)
    }

    private func addSubviews() {
        layer.cornerRadius = padding
        layer.masksToBounds = true

        allSubviews().forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        setConstraints()
        isLoading = true
    }

    private func configureSubviews() {
        configureImageViews()
        configureTextLabels()
    }

    private func configureImageViews() {
        backgroundImageView.layer.cornerRadius = padding
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.backgroundColor = UIColor(hexString: cardBackgroundColor)
        if let backgroundUrl = cardBackgroundImageUrl {
            backgroundImageView.setImage(url: backgroundUrl)
        }
        backgroundImageView.contentMode = .scaleAspectFit

        merchantLogoView.setImage(url: merchantLogoImageUrl)
        merchantLogoView.contentMode = .scaleAspectFit
    }

    private func configureTextLabels() {
        let textColor = UIColor(hexString: cardFontColor)
        amountLabel.textColor = textColor
        amountLabel.text = amountString
        amountLabel.font = CatchFont.heading1

        expirationLabel.textColor = textColor
        expirationLabel.text = expirationString
        expirationLabel.font = CatchFont.bodySmall
    }

    // MARK: - Autolayout
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // Merchant Reward Card Constraints
            heightAnchor.constraint(equalToConstant: cardHeight),
            widthAnchor.constraint(equalToConstant: cardWidth),

            // Background Image Constraints
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Merchant Logo Constraints
            merchantLogoView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            merchantLogoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            merchantLogoView.widthAnchor.constraint(equalToConstant: merchantLogoWidth),
            merchantLogoView.heightAnchor.constraint(
                equalTo: merchantLogoView.widthAnchor,
                multiplier: UIConstant.merchantLogoAspectRatio),

            // Amount Label Constraints
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            // Expiration Label Constraints
            expirationLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor),
            expirationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            expirationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            expirationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)

        ])
    }

    private func allSubviews() -> [UIView] {
        return [backgroundImageView, merchantLogoView, amountLabel, expirationLabel]
    }
}
