//
//  ExpressCheckoutCallout.swift
//  Catch
//
//  Created by Lucille Benoit on 10/6/22.
//

import UIKit

public class ExpressCheckoutCallout: BaseEarnRedeemWidget {

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
     Initializes a new express checkout callout widget which is designed to be displayed in
     merchant checkout flows in which an express checkout option is present.
     - Parameter price: The cost in cents that a consumer would pay for the item(s) without redeeming Catch credit.
     - Parameter borderStyle: The style of border the widget renders. Defaults to a slightly rounded rectangular border.
     - Parameter theme: The Catch color theme. If no theme is set, the default "light-color" theme will be used.
     - Parameter styleOverrides: Overrides for the widget's styling.
     - Parameter items: A list of all items included in the order. Used to calculate item-based rewards.
     - Parameter userCohorts: A list of user cohorts that the signed in user qualifies for.
     Used to calculate cohort-based rewards.
     */
    public init(price: Int? = nil,
                borderStyle: BorderStyle = .roundedRect,
                theme: Theme? = nil,
                styleOverrides: LabelWidgetStyle? = nil,
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
        if let superviewSize = superview?.bounds.size, superviewSize != .zero {
            // Split the stack into two lines if content width is larger than available width
            needsMultiLineLayout = (contentWidth() > superviewSize.width)
        }

        if needsMultiLineLayout {
            configureTwoLineLayout()
        } else {
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
