//
//  Callout.swift
//  Catch
//
//  Created by Lucille Benoit on 10/25/22.
//

import UIKit

/**
 The Callout widget shows consumers how much Catch credit they could earn or redeem
 based on the price of the item(s) they're considering (e.g. when viewing a product detail
 page or their cart).

 The widget includes a trigger that, when clicked, opens a modal
 which displays more detailed informational content about paying with Catch and earning
 rewards on the merchant's site. The widget automatically recognizes consumers who are
 currently signed in to Catch, and tailors the messaging to them if they have rewards that
 are available to redeem with the merchant.

 The Callout widget also makes use of its price, items, and userCohorts attributes to calculate
 rewards the user will earn on the current item (if implemented on product detail page) or
 on the current order (if implemented in the cart or during the checkout flow).
 */
public class Callout: _BaseEarnRedeemWidget {
    // MARK: - Properties
    private var orPrefix = false
    private var needsMultiLineLayout: Bool = false

    /// The logo and info button are grouped into a horizontal stack so that they never end up on separate lines.
    private var logoInfoStack: UIStackView {
        let stack = UIStackView()
        stack.spacing = Layout.logoInfoButtonSpacing
        stack.addArrangedSubview(logo)
        stack.addArrangedSubview(infoButton)
        stack.axis = .horizontal
        return stack
    }

    private struct Layout {
        static let verticalStackSpacing = UIConstant.smallMediumSpacing
        static let horizontalStackSpacing = UIConstant.smallSpacing
        static let logoInfoButtonSpacing = UIConstant.smallMediumSpacing
    }

    override var orderedSubviews: [UIView] {
        return [label, logoInfoStack]
    }

    override var widgetType: StyleResolver.WidgetType { return .callout }

    // MARK: - Initializers

    /**
     Initializes a ``Callout`` widget.
     - Parameter price: The cost in cents that a consumer would pay for the item(s) without
     redeeming Catch credit. If not set, the widgets will display the rewards rate (e.g. “Earn 10% credit”)
     rather than a specific rewards value (e.g., "Earn $24.00 credit"). If provided, the price must be a
     positive number. A negative price will be treated as if the price is not set at all.
     - Parameter borderStyle: The ``BorderStyle`` that the widget renders.
     Defaults to no border.
     - Parameter orPrefix: If or-prefix is set, the word "or" is prepended into the displayed messaging
     (e.g. "or earn $23.00 credit" instead of "Earn $23.00 credit".
     - Parameter theme: The Catch color ``Theme``. If no theme is set, the default
     ``Theme/lightColor`` theme will be used.
     - Parameter styleOverrides: Style overrides which can be used to override the theme's default
     appearance (ex. fonts and colors).
     - Parameter items: A list of items included in the order (i.e. on PDP, this would be the single item
     displayed on the page. On the cart/checkout pages, this would be a list of all items included in the order).
     This is used to calculate SKU-based rewards.
     - Parameter userCohorts: A list of user cohorts that the signed in user qualifies for. Used to calculate
     user cohort based rewards.
     */
    public init(price: Int? = nil,
                borderStyle: BorderStyle = .none,
                orPrefix: Bool = false,
                theme: Theme? = nil,
                styleOverrides: InfoWidgetStyle? = nil,
                items: [Item]? = nil,
                userCohorts: [String]? = nil) {
        self.orPrefix = orPrefix
        let insets = UIEdgeInsets(vertical: UIConstant.smallSpacing,
                                  horizontal: UIConstant.mediumSpacing)

        let earnRedeemLabelConfig: EarnRedeemLabelType = .callout(hasOrPrefix: orPrefix)
        let borderConfig = BorderConfig(insets: insets, style: borderStyle)
        let config = BaseWidgetConfig(price: price,
                                      theme: theme,
                                      styleOverrides: styleOverrides,
                                      borderConfig: borderConfig,
                                      items: items,
                                      userCohorts: userCohorts,
                                      earnRedeemLabelConfig: earnRedeemLabelConfig)
        super.init(config: config)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Stack Layout Functions

    override func configureStack() {
        label.numberOfLines = 1
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = Layout.horizontalStackSpacing
    }

    override public func layoutSubviews() {
        // Split the stack into two lines if content width is larger than available width
        needsMultiLineLayout = (contentWidth() > frame.width + 1)

        // Configure two line layout if stack is not yet vertical
        if needsMultiLineLayout && stack.axis != .vertical {
            configureMultiLineStack()
        }

        // Configure two line layout if stack is not yet horizontal
        if !needsMultiLineLayout && stack.axis != .horizontal {
            configureSingleLineStack()
        }

        super.layoutSubviews()
    }

    private func contentWidth() -> CGFloat {
        let stackSpacing = stack.spacing + Layout.logoInfoButtonSpacing + insets.left + insets.right
        var lineWidth: CGFloat = label.intrinsicContentSize.width
        + logo.bounds.width
        + infoButton.bounds.width
        lineWidth += stackSpacing
        return lineWidth
    }

    private func configureMultiLineStack() {
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Layout.verticalStackSpacing
    }

    private func configureSingleLineStack() {
        stack.axis = .horizontal
        stack.spacing = Layout.horizontalStackSpacing
    }
}
