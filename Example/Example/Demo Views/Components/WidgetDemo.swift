//
//  WidgetDemoView.swift
//  Example
//
//  Created by Lucille Benoit on 11/3/22.
//

import Catch
import UIKit

/**
Base class used to demo a Catch widget and any configuration components.
*/
class WidgetDemo: UIView {
    internal var title: String
    internal var widget: UIView
    internal var theme: Theme = .lightColor
    internal var price: Int = 0

    lazy var label = WidgetLabel(text: title)

    lazy var widgetStack: UIStackView = {
        let stack = UIStackView()

        stack.addArrangedSubview(widget)
        stack.layoutMargins = UIEdgeInsets(
            top: 0,
            left: Constant.defaultMargin,
            bottom: 0,
            right: Constant.defaultMargin
        )
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .center
        return stack
    }()

    var components: [UIView] {
        return [label, widgetStack]
    }

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        for subview in components {
            stack.addArrangedSubview(subview)
        }
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Constant.demoStackSpacing
        return stack
    }()

    init(title: String, widget: UIView) {
        self.title = title
        self.widget = widget
        super.init(frame: .zero)

        addSubview(stack)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateWidget(_ widget: UIView) {
        widgetStack.arrangedSubviews[0].removeFromSuperview()
        self.widget = widget
        widgetStack.addArrangedSubview(widget)
    }

    func setPrice(price: Int) {
        self.price = price
        if let earnRedeemWidget = widget as? BaseEarnRedeemWidget {
            earnRedeemWidget.setPrice(price)
        } else if let purchaseConfirmation = widget as? PurchaseConfirmation {
            purchaseConfirmation.setEarnedAmount(price)
        }
    }

    func setTheme(theme: Theme) {
        self.theme = theme
        if let baseWidget = widget as? BaseWidget {
            baseWidget.setTheme(theme)
        } else if let logo = widget as? CatchLogo {
            logo.setTheme(theme)
        }
    }

    private func setConstraints() {
        widget.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
