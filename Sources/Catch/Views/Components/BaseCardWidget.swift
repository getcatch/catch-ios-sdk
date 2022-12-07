//
//  BaseCardWidget.swift
//  Catch
//
//  Created by Lucille Benoit on 11/18/22.
//

import UIKit

public class BaseCardWidget: BaseWidget {

    // MARK: - Subviews
    internal lazy var merchantCard = MerchantRewardCard()
    internal var externalLinkButton: ExternalLinkButton
    private var flexButton: UIButton {
        return externalLinkButton
    }

    // MARK: - View Configuration Properties

    /**
     Constraints to pin the button to the edges of the parent view.
     */
    private lazy var extendedButtonConstraints: [NSLayoutConstraint] = [
        externalLinkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
        externalLinkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right)
    ]

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: frame.height)
    }

    override var additionalConstraints: [NSLayoutConstraint] {
        return [logo.heightAnchor.constraint(equalToConstant: UIConstant.largeLogoHeight)]
    }

    internal var viewModel: AnyObject?

    // MARK: - Initializers

    /**
     Internal initializers prevents others from initializing the BaseCardWidget class directly.
     */
    internal init(initialAmount: Int = 0,
                  buttonTitle: String = String(),
                  buttonURL: URL? = nil,
                  theme: Theme?,
                  borderStyle: BorderStyle,
                  insets: UIEdgeInsets = UIEdgeInsets(inset: UIConstant.largeSpacing)) {
        let buttonStyle = ActionButtonStyle(textStyle: .default, backgroundColor: theme?.accentColor)
        self.externalLinkButton = ExternalLinkButton(title: buttonTitle,
                                                     url: buttonURL,
                                                     style: buttonStyle)
        // pill borders will be treated like rounded rect borders for the card based widgets
        let border: BorderStyle = borderStyle == .pill ? .roundedRect : borderStyle
        let config = BaseWidgetConfig(price: initialAmount,
                                      theme: theme,
                                      borderConfig: BorderConfig(insets: insets, style: border))
        super.init(config: config)
        externalLinkButton.translatesAutoresizingMaskIntoConstraints = false
        setConstraints()
        didUpdateTheme()
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }

    // MARK: - Public View Layout functions
    override public func layoutSubviews() {
        setExpandingLayoutPriorities()
        layoutFlexButton()
        merchantCard.addShadow(offset: UIConstant.merchantCardShadowOffset,
                               color: .black,
                               radius: UIConstant.merchantCardShadowRadius,
                               opacity: UIConstant.merchantCardShadowOpacity)
        super.layoutSubviews()
    }

    // MARK: - Internal Functions
    override internal func configureStack() {
        stack.spacing = UIConstant.largeSpacing
        stack.setCustomSpacing(UIConstant.extraLargeSpacing, after: merchantCard)
        stack.axis = .vertical
        stack.alignment = .leading
    }

    override internal func didUpdateTheme() {
        super.didUpdateTheme()
        let textStyle = TextStyle(font: CatchFont.buttonLabel,
                                  textColor: theme.buttonTextColor)
        let buttonStyle = ActionButtonStyle(textStyle: textStyle,
                                            backgroundColor: theme.accentColor)

        externalLinkButton.setStyle(style: buttonStyle)
    }

    override internal func createBenefitTextStyle() -> WidgetTextStyle {
        theme.widgetTextStyle(size: .large)
    }

    /**
     Updates the layout of the external link button based on the width of the view.
     For views wider that the max button width, the button hugs its content.
     Otherwise, the button fills the available space.
     */
    private func layoutFlexButton() {
        if frame.width > UIConstant.maxExternalLinkButtonWidth {
            NSLayoutConstraint.deactivate(extendedButtonConstraints)
        } else {
            NSLayoutConstraint.activate(extendedButtonConstraints)
        }
        layoutIfNeeded()
    }
}
