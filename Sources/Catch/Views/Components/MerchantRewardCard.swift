//
//  MerchantRewardCard.swift
//  Catch
//
//  Created by Lucille Benoit on 10/11/22.
//

import UIKit

class MerchantRewardCard: UIView {
    // MARK: - Subviews
    var backgroundImageView: RemoteImageView = RemoteImageView(frame: .zero)
    var merchantLogoView: RemoteImageView = RemoteImageView(frame: .zero)
    var amountLabel: UILabel = UILabel(frame: .zero)
    var expirationLabel: UILabel = UILabel(frame: .zero)

    // MARK: - Private configuration properties
    private let merchantLogoImageUrl: String
    private let cardFontColor: String
    private let cardBackgroundImageUrl: String?
    private let cardBackgroundColor: String
    private var amountString: String?
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

    // MARK: - Initializers
    /**
     Initializes a merchant card component.
     - Parameter merchantLogoImageUrl: The url string for the merchant logo image.
     - Parameter cardFontColor: A hex string representing the card font color.
     - Parameter cardBackgroundImageUrl: A string representing the optional
     merchant card background image. Defaults to nil.
     - Parameter cardBackgroundColor: A hex string representing the card background color.
     - Parameter amountString: A formatted price string representing the reward amount.
     - Parameter expirationString: A formatted date string representing the reward expiration.
     */
    init(merchantLogoImageUrl: String,
         cardFontColor: String,
         cardBackgroundImageUrl: String? = nil,
         cardBackgroundColor: String,
         amountString: String,
         expirationString: String) {

        self.merchantLogoImageUrl = merchantLogoImageUrl
        self.cardFontColor = cardFontColor
        self.cardBackgroundImageUrl  = cardBackgroundImageUrl
        self.cardBackgroundColor = cardBackgroundColor
        self.amountString = amountString
        self.expirationString = expirationString

        super.init(frame: .zero)

        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Configuration
    private func configureViews() {
        layer.cornerRadius = padding
        layer.masksToBounds = true

        configureImageViews()
        configureTextLabels()

        allSubviews().forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        setConstraints()
    }

    private func configureImageViews() {
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
