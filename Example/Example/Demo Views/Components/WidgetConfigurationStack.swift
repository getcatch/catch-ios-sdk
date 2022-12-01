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
    let insets: UIEdgeInsets?

    lazy var stack: UIStackView = {
        let stack = UIStackView()

        for view in arrangedSubviews {
            stack.addArrangedSubview(view)
        }
        configureStackInsets(stack)
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = Constant.configurationViewSpacing
        return stack
    }()

    // MARK: - Initializers

    init(subviews: [UIView], insets: UIEdgeInsets? = Constant.configurationStackInsets) {
        self.arrangedSubviews = subviews
        self.insets = insets
        super.init(frame: .zero)
        addConstrainedSubviewToView(stack)
        backgroundColor = Constant.secondaryBackgroundColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Helpers
    func configureStackInsets(_ stack: UIStackView) {
        if let insets = insets {
            stack.layoutMargins = insets
            stack.isLayoutMarginsRelativeArrangement = true
        }
    }
}
