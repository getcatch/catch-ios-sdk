//
//  Callout.swift
//  Catch
//
//  Created by Lucille Benoit on 10/25/22.
//

import UIKit

public class Callout: BaseEarnRedeemWidget {
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

    public init(price: Int? = nil,
                borderStyle: BorderStyle = .roundedRect,
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
        needsMultiLineLayout = (contentWidth() > frame.width)

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
