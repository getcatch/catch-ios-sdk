//
//  LabelTextField.swift
//  Example
//
//  Created by Lucille Benoit on 11/29/22.
//

import UIKit

/**
A horizontally stacked label and text field.
*/
class LabelTextField: UIView, UITextFieldDelegate {
    var text: String {
        return textField.text ?? String()
    }

    lazy var label = UILabel(frame: .zero)
    lazy var textField = createTextField()

    lazy var stack: UIStackView = {
        let stack = UIStackView()

        stack.addArrangedSubview(label)
        stack.addArrangedSubview(textField)

        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = Constant.configurationViewSpacing
        return stack
    }()

    // MARK: - Initializers

    init(title: String) {
        super.init(frame: .zero)
        configureLabel(with: title)
        textField.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        addConstrainedSubviewToView(stack)
        textField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Helpers

    private func configureLabel(with title: String) {
        label.text = title
        label.font = Constant.bodyFont
    }

    private func createTextField() -> UITextField {
        let textView = UITextField(frame: .zero)
        textView.borderStyle = .roundedRect
        textView.backgroundColor = .systemGray6
        textView.textColor = .placeholderText
        textView.font = Constant.bodyFont
        return textView
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
