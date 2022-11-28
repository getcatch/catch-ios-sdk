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

    lazy var label = WidgetLabel(text: title)
    private lazy var leftSpacer = UIView(frame: .zero)
    private lazy var rightSpacer = UIView(frame: .zero)

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

    func setPrice(price: Int) {}

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
