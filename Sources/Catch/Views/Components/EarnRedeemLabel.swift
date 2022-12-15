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

    // MARK: - Properties
    internal var isLoading: Bool = false {
        didSet {
            if isLoading {
                showSkeleton()
            } else {
                hideSkeleton()
            }
        }
    }
    private var type: EarnRedeemLabelType

    internal var style: WidgetTextStyle {
        didSet {
            updateAttributedString()
        }
    }
    private var didTapLink: () -> Void
    private var linkRange = NSRange(location: 0, length: 0)

    private var reward: Reward {
        didSet {
            isLoading = false
        }
    }

    private var prefixString: NSAttributedString {
        let prefixString = type == .callout(hasOrPrefix: true)
        ? LocalizedString.or.localized + " "
        : ""
        return NSAttributedString(string: prefixString, style: style.textStyle ?? .default)
    }

    private var fillerString: NSAttributedString {
        let text = StringFormat.getEarnRedeemFillerText(type: type)
        return NSAttributedString(string: text, style: style.textStyle ?? .default)
    }

    // MARK: - Initializers

    /**
     Creates and initializes a new EarnRedeemLabel view with the given type, amount, styling and handler.
     - Parameter type: The type of widget using the EarnRedeemLabel and its associated values.
     ex. .callout(hasOrPrefix)
     - Parameter style: The attributed text styles to apply to the filler, earn, and redeem texts.
     - Parameter tapHandler: The callback function to be called when the link is tapped.
     */
    init(type: EarnRedeemLabelType,
         style: WidgetTextStyle,
         tapHandler: @escaping () -> Void) {
        self.type = type
        self.style = style
        self.didTapLink = tapHandler
        self.reward = .percentRate(Constant.defaultRewardsRate)
        super.init(frame: .zero)

        textAlignment = .left
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

    func updateData(reward: Reward, type: EarnRedeemLabelType) {
        self.reward = reward
        self.type = type
        updateAttributedString()
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
        let highlightStyle = reward.hasRedeemableCredits
        ? style.redeemTextStyle
        : style.earnTextStyle(isUnderlined: type.benefitTextIsUnderlined)
        let earnRedeemText = StringFormat.getEarnRedeemText(
            type: type,
            reward: reward
        ).nonBreaking

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
