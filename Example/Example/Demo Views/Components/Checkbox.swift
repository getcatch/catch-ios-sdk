//
//  Checkbox.swift
//  Example
//
//  Created by Lucille Benoit on 11/28/22.
//

import UIKit

// MARK: - Checkbox Delegate
protocol CheckboxDelegate: AnyObject {
    func didTapCheckbox(isSelected: Bool)
}

// MARK: - Checkbox View
class Checkbox: UIButton {
    // Delegate to handle checking/unchecking actions
    weak var delegate: CheckboxDelegate?

    // Images
    let checkedImage = UIImage.init(systemName: "checkmark.square.fill")
    let uncheckedImage = UIImage.init(systemName: "square")

    // Checked State
    var isChecked = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }

    // MARK: - Initializers

    init(title: String) {
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        titleLabel?.font = Constant.bodyFont
        setInsets(forContentPadding: .zero, imageTitlePadding: Constant.defaultMargin)
        setImage(uncheckedImage, for: .normal)
        addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        backgroundColor = .clear
        tintColor = UIColor.systemGray
        setTitleColor(UIColor.label, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked.toggle()
            delegate?.didTapCheckbox(isSelected: isChecked)
        }
    }
}
