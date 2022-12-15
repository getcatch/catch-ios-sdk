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

    override var orderedSubviews: [UIView] {
        return [label, logo, infoButton]
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

    // MARK: - Stack Layout Overrides

    override func configureStack() {
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = UIConstant.smallSpacing
        stack.setCustomSpacing(UIConstant.smallMediumSpacing, after: logo)
    }
}
