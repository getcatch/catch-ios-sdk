//
//  WidgetLabel.swift
//  Example
//
//  Created by Lucille Benoit on 11/3/22.
//

import UIKit

class WidgetLabel: UIView {
    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let text: String

    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        addSubview(label)
        setConstraints()
        backgroundColor = Constant.headerColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraints() {
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.defaultMargin),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: Constant.headerHeight)
        ])
    }
}
