//
//  PaymentMethod.swift
//  Catch
//
//  Created by Lucille Benoit on 10/19/22.
//

import UIKit

public class PaymentMethod: BaseWidget {
    /**
     Whether or not the widget is in a disabled state.
     Disabled payment method widgets are displayed slightly greyed out with interaction disabled.
     */
    public var disabled: Bool {
        didSet {
            setDisabledState()
        }
    }

    /**
     Whether or not the widget is in a selected state.
     */
    public var selected: Bool

    private var variant: PaymentMethodVariant
    lazy private var infoButton = InfoButton(style: infoButtonStyle)

    private lazy var labelInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(infoButton)
        stack.spacing = UIConstant.microSpacing
        stack.setCustomSpacing(UIConstant.smallMediumSpacing, after: label)
        stack.setCustomSpacing(0, after: infoButton)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return stack
    }()

    override var additionalConstraints: [NSLayoutConstraint] {
        return [logo.heightAnchor.constraint(equalToConstant: UIConstant.largeLogoHeight)]
    }

    override var orderedSubviews: [UIView] {
        return variant == .compact ? [labelInfoStack] : [logo, labelInfoStack]
    }

    // MARK: - Initializers
    /**
     Initializes a new payment method widget which is designed specifically to be displayed in
     merchant checkout UI's where a consumer may select Catch as their payment method.
     - Parameter price: The cost in cents that a consumer would pay for the item(s) without redeeming Catch credit.
     - Parameter selected: Whether or not the widget is in a selected state.
     - Parameter disabled: Whether or not the widget is in a disabled state.
     - Parameter theme: The Catch color theme. If no theme is set, the default will be used.
     - Parameter variant: The "compact" variant of the payment method will not render the Catch logo.
     The "logo-compact" variant will render the Catch logo and reward text.
     - Parameter items: A list of all items included in the order. Used to calculate item-based rewards.
     - Parameter userCohorts: A list of user cohorts that the signed in user qualifies for.
     Used to calculate cohort-based rewards.
     */
    public init(price: Int = 0,
                selected: Bool = false,
                disabled: Bool = false,
                theme: Theme? = nil,
                variant: PaymentMethodVariant = .standard,
                items: [Item]? = nil,
                userCohorts: [String]? = nil
    ) {
        self.variant = variant
        self.disabled = disabled
        self.selected = selected
        let earnRedeemLabelConfig: EarnRedeemLabelType = .paymentMethod(isCompact: variant == .logoCompact)
        let config = BaseWidgetConfig(price: price,
                                      theme: theme,
                                      items: items,
                                      userCohorts: userCohorts,
                                      earnRedeemLabelConfig: earnRedeemLabelConfig)
        super.init(config: config)
        configureInfoButton()
        setDisabledState()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Theme Handling

    override func didUpdateTheme() {
        super.didUpdateTheme()
        configureInfoButton()
    }

    // MARK: - AutoLayout

    override func configureStack() {
        if variant != .compact {
            stack.setCustomSpacing(UIConstant.mediumSpacing, after: logo)
        }
        stack.alignment = .center
        stack.axis = .horizontal
    }
}

// MARK: - Private Helpers
private extension PaymentMethod {

    /**
     Updates the transparency and interactivity of the widget based on the disabled flag.
     */
    private func setDisabledState() {
        let transparency = disabled ? UIConstant.disabledAlpha : 1
        logo.alpha = transparency
        label.alpha = transparency
        label.isUserInteractionEnabled = !disabled
    }

    private func configureInfoButton() {
        infoButton.setStyle(NSAttributedStringStyle.infoButtonStyle(theme: theme))
    }
}
