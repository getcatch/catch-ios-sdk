//
//  SegmentedControlSection.swift
//  Example
//
//  Created by Lucille Benoit on 11/3/22.
//

import UIKit

protocol SegmentedControlDelegate: AnyObject {
    func didSelectItem(named key: String, sender: SegmentedControlSection)
}

/**
A stack view which displays a title and a UISegmentedControl view horizontally.
*/
class SegmentedControlSection: UIView {
    // Delegate responsible for handling didChange actions
    weak var delegate: SegmentedControlDelegate?

    // Label for the segmented control section
    let title: String?

    // Names for the segmented control items
    let items: [String]

    lazy var label = UILabel()
    lazy var segmentedControl = UISegmentedControl(items: items)

    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(segmentedControl)
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = Constant.defaultMargin
        return stack
    }()

    // MARK: - Initializers

    /**
    Initializes a view containing a labeled UISegmentedControl view
    - Parameter title: The text to be shown to the left of the segmented control view.
    - Parameter items: The ordered labels for each segmented control item.
    */
    init(title: String?, items: [String]) {
        self.title = title
        self.items = items
        super.init(frame: .zero)
        addSubview(stack)
        configureSegmentedControl()
        configureLabel()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Helpers

    private func configureLabel() {
        label.text = title
        label.font = Constant.bodyFont
    }

    private func configureSegmentedControl() {
        segmentedControl.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        segmentedControl.selectedSegmentTintColor = UIColor.systemGray6
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: Constant.bodyFont], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        segmentedControlDidChange(segmentedControl)
    }

    @objc
    private func segmentedControlDidChange(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if let key = sender.titleForSegment(at: index) {
            delegate?.didSelectItem(named: key, sender: self)
        }
    }

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
