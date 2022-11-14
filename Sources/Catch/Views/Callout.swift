//
//  Callout.swift
//  Catch
//
//  Created by Lucille Benoit on 10/25/22.
//

import UIKit

public class Callout: BaseWidget {
    // MARK: - Properties
    private var orPrefix = false

    lazy private var infoButton = InfoButton(style: infoButtonStyle)

    override var orderedSubviews: [UIView] {
        return [label, logo, infoButton]
    }

    // MARK: - Initializers

    public init(price: Int? = nil,
                borderStyle: BorderStyle = .roundedRect,
                orPrefix: Bool = false,
                theme: Theme? = nil,
                items: [Item]? = nil,
                userCohorts: [String]? = nil) {
        self.orPrefix = orPrefix
        let insets = UIEdgeInsets(vertical: UIConstant.smallSpacing,
                                  horizontal: UIConstant.mediumSpacing)

        let earnRedeemLabelConfig: EarnRedeemLabelType = .callout(hasOrPrefix: orPrefix)
        let borderConfig = BorderConfig(insets: insets, style: borderStyle)
        let config = BaseWidgetConfig(price: price,
                                      theme: theme,
                                      borderConfig: borderConfig,
                                      items: items,
                                      userCohorts: userCohorts,
                                      earnRedeemLabelConfig: earnRedeemLabelConfig)
        super.init(config: config)
        configureInfoButton()
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

    override func didUpdateTheme() {
        super.didUpdateTheme()
        configureInfoButton()
    }

    private func configureInfoButton() {
        infoButton.setStyle(NSAttributedStringStyle.infoButtonStyle(theme: theme))
    }
}
