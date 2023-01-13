//
//  ExpressCheckoutCallout.swift
//  Catch
//
//  Created by Lucille Benoit on 10/6/22.
//

import UIKit

/**
 The Express Checkout Callout widget displays similar informational content as the Callout with additional
 messaging on where to find Catch in the checkout flow.

 It is intended to be displayed in merchant checkout flows in which an express checkout option is present
 --since Catch can only be selected on the final step of checkout, this messaging is meant to reduce
 confusion if the consumer intends to pay with Catch but does not see it displayed as an express checkout
 option. The widget also includes a button to open an informational modal with more detailed literature about
 paying with Catch and with links to visit Catch's marketing website.

 The Express Checkout Callout widget also makes use of its price, items, and userCohorts attributes to
 calculate rewards the user will earn on the current purchase.
 */
public class ExpressCheckoutCallout: _BaseEarnRedeemWidget {

    // MARK: - Subviews
    private var paymentStepLabel = UILabel(frame: .zero)
    private lazy var spacer = UIView()
    private var needsMultiLineLayout = true

    private lazy var topStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(logo)
        stack.alignment = .leading
        stack.axis = .horizontal
        stack.spacing = UIConstant.smallSpacing
        return stack
    }()

    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(paymentStepLabel)
        stack.addArrangedSubview(infoButton)
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = UIConstant.smallMediumSpacing
        return stack
    }()

    override var orderedSubviews: [UIView] {
        return [topStack, bottomStack]
    }

    override var widgetType: StyleResolver.WidgetType { return .expressCheckoutCallout }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: frame.height)
    }

    // MARK: - Initializers

    /**
     Initializes an ``ExpressCheckoutCallout`` widget.
     - Parameter price: The cost in cents that a consumer would pay for the item(s) without redeeming Catch credit.
     - Parameter borderStyle: The ``BorderStyle`` that the widget renders.
     Defaults to the ``BorderStyle/roundedRect`` style.
     - Parameter theme: The Catch color ``Theme``. If no theme is set, the default
     ``Theme/lightColor`` theme will be used.
     - Parameter styleOverrides: Style overrides which can be used to override the theme's default
     appearance (ex. fonts and colors).
     - Parameter items: A list of all items included in the order. Used to calculate item-based rewards.
     - Parameter userCohorts: A list of user cohorts that the signed in user qualifies for.
     Used to calculate cohort-based rewards.
     */
    public init(price: Int? = nil,
                borderStyle: BorderStyle = .roundedRect,
                theme: Theme? = nil,
                styleOverrides: InfoWidgetStyle? = nil,
                items: [Item]? = nil,
                userCohorts: [String]? = nil) {
        let earnRedeemLabelConfig: EarnRedeemLabelType = .expressCheckoutCallout
        let insets = UIEdgeInsets(inset: UIConstant.largeSpacing)
        let borderConfig = BorderConfig(insets: insets, style: borderStyle)
        let config = BaseWidgetConfig(price: price,
                                      theme: theme,
                                      styleOverrides: styleOverrides,
                                      borderConfig: borderConfig,
                                      items: items,
                                      userCohorts: userCohorts,
                                      earnRedeemLabelConfig: earnRedeemLabelConfig)

        super.init(config: config)
        configurePaymentStepLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Theming

    override func didUpdateTheme() {
        super.didUpdateTheme()
        paymentStepLabel.attributedText = paymentStepString()
    }

    override func createBenefitTextStyle() -> WidgetTextStyle {
        return resolvedStyling?.widgetTextStyle ?? theme.widgetTextStyle(size: .regular)
    }

    // MARK: - Autolayout

    override func configureStack() {
        setExpandingLayoutPriorities()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalCentering
        stack.spacing = UIConstant.smallSpacing
    }

    override public func layoutSubviews() {
        // Split the stack into two lines if content width is larger than available width
        needsMultiLineLayout = (contentWidth() > frame.width)

        // Configure two line layout if stack is not yet vertical
        if needsMultiLineLayout && stack.axis != .vertical {
            configureTwoLineLayout()
        }

        // Configure one line layout if stack is not yet horizontal
        if !needsMultiLineLayout && stack.axis != .horizontal {
            configureOneLineLayout()
        }

        super.layoutSubviews()
    }
}

// MARK: - Private Helpers

private extension ExpressCheckoutCallout {

    func configurePaymentStepLabel() {
        paymentStepLabel.attributedText = paymentStepString()
        paymentStepLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentStepLabel.sizeToFit()
    }

    func paymentStepString() -> NSMutableAttributedString {
        let textStyling = createBenefitTextStyle()
        let style = textStyling.textStyle
        var boldStyle = style
        boldStyle?.font = textStyling.benefitTextStyle?.font

        let mutableString = NSMutableAttributedString()

        var paymentStepText = "\(LocalizedString.findUsAt.localized) "

        // Append the double dash character to the beginning of the payment step string for one-line layout
        if !needsMultiLineLayout {
            paymentStepText = " \(UIConstant.enDash)  \(paymentStepText)"
        }
        mutableString.append(NSAttributedString(string: paymentStepText, style: style))
        mutableString.append(NSAttributedString(string: LocalizedString.paymentStep.localized, style: boldStyle))
        return mutableString
    }

    func configureOneLineLayout() {
        stack.axis = .horizontal
        stack.distribution = .fill
        spacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
        stack.addArrangedSubview(spacer)
        paymentStepLabel.attributedText = paymentStepString()
    }

    func configureTwoLineLayout() {
        stack.axis = .vertical
        stack.removeArrangedSubview(spacer)
        paymentStepLabel.attributedText = paymentStepString()
    }

    func contentWidth() -> CGFloat {
        let stackSpacing = 4 * stack.spacing + insets.left + insets.right
        var lineWidth: CGFloat = label.intrinsicContentSize.width
        + logo.bounds.width
        + paymentStepLabel.intrinsicContentSize.width
        + infoButton.bounds.width
        lineWidth += stackSpacing
        return lineWidth
    }
}
