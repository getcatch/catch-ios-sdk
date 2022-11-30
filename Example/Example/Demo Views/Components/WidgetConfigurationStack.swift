//
//  WidgetConfigurationStack.swift
//  Example
//
//  Created by Lucille Benoit on 11/29/22.
//

import UIKit

/**
Stack view displaying all components used to configure the widget demos such as border style segmented controls and checkboxes.
*/
class WidgetConfigurationStack: UIView {
    let arrangedSubviews: [UIView]

    lazy var stack: UIStackView = {
        let stack = UIStackView()

        for view in arrangedSubviews {
            stack.addArrangedSubview(view)
        }

        stack.layoutMargins = UIEdgeInsets(
            top: 1.5 * Constant.configurationViewSpacing,
            left: Constant.defaultMargin,
            bottom: 1.5 * Constant.configurationViewSpacing,
            right: Constant.defaultMargin
        )
        stack.isLayoutMarginsRelativeArrangement = true

        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .leading
        stack.spacing = Constant.configurationViewSpacing
        return stack
    }()

    // MARK: - Initializers

    init(subviews: [UIView]) {
        self.arrangedSubviews = subviews
        super.init(frame: .zero)
        addSubview(stack)
        setConstraints()
        backgroundColor = Constant.secondaryBackgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Helpers

    private func setConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}
