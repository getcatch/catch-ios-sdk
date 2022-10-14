//
//  EarnRedeemLabel.swift
//  
//
//  Created by Lucille Benoit on 10/11/22.
//

import UIKit

/**
A UILabel displaying tappable earn/redeem reward messaging with a skeleton loading view.
 */
class EarnRedeemLabel: UILabel, Skeletonizable {
    struct Style {
        var filler: NSAttributedStringStyle = .default
        var earn: NSAttributedStringStyle = .default
        var redeem: NSAttributedStringStyle = .default
    }

    // MARK: - Properties
    private var type: EarnRedeemLabelType
    private var style: Style
    private var didTapLink: () -> Void
    private var linkRange = NSRange(location: 0, length: 0)
    private var hasRedeemableCredits = false
    private var amount: String = StringFormat.percentString(from: Constant.defaultRewardsRate) {
        didSet {
            hideSkeleton()
            updateAttributedString()
        }
    }

    private lazy var prefixString: NSAttributedString = {
        let prefixString = type == .callout(hasOrPrefix: true)
        ? LocalizedString.or.localized + " "
        : ""
        return NSAttributedString(string: prefixString, style: style.filler)
    }()

    private lazy var fillerString: NSAttributedString = {
        let text = StringFormat.getEarnRedeemFillerText(type: type)
        return NSAttributedString(string: text, style: style.filler)
    }()

    // MARK: - Initializers

    /**
     Creates and initializes a new EarnRedeemLabel view with the given type, amount, styling and handler.
     - Parameter type: The type of widget using the EarnRedeemLabel and its associated values.
     ex. .callout(hasOrPrefix)
     - Parameter style: The attributed text styles to apply to the filler, earn, and redeem texts.
     - Parameter tapHandler: The callback function to be called when the link is tapped.
     */
    init(type: EarnRedeemLabelType,
         style: Style,
         tapHandler: @escaping () -> Void) {
        self.type = type
        self.style = style
        self.didTapLink = tapHandler
        super.init(frame: .zero)

        textAlignment = .center
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
        sizeToFit()

        showSkeleton()
        updateAttributedString()
        addTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /**
    Updates the amount to earn or redeem once data has loaded. Also hides the skeleton loading view.
     - Parameter amount: Formatted string signifying the amount to be earned or redeemed ex. "10%" or "$20"
     - Parameter hasRedeemableCredits: Whether or not the user has redeemable credits to use.
     */
    func updateAmountRedeemable(amount: String, hasRedeemableCredits: Bool) {
        self.hasRedeemableCredits = hasRedeemableCredits
        self.amount = amount
    }

    // MARK: - Private Helpers

    private func addTapGesture() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        // Only react to tap if tap was in range of link text
        if sender.didTapAttributedTextInLabel(label: self, inRange: linkRange) {
            didTapLink()
        }
    }

    private func updateAttributedString() {
        let mutableString = NSMutableAttributedString()
        let highlightStyle = hasRedeemableCredits ? style.redeem : style.earn
        let earnRedeemText = StringFormat.getEarnRedeemText(
            type: type,
            amountString: amount,
            hasRedeemableCredits: hasRedeemableCredits
        )

        let highlightString = NSAttributedString(string: earnRedeemText, style: highlightStyle)

        // Append "or" prefix or empty string depending on widget type
        mutableString.append(prefixString)

        if type.prependFillerString {
            mutableString.append(fillerString)
        }

        // Append the highlight string and save link range for gesture recognizer
        linkRange = NSRange(location: mutableString.length,
                            length: highlightString.length)
        mutableString.append(highlightString)

        if !type.prependFillerString && !type.hideFillerString {
            mutableString.append(fillerString)
        }

        attributedText = mutableString
    }

}
