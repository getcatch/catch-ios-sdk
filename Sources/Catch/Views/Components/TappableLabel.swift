//
//  TappableLabel.swift
//  
//
//  Created by Lucille Benoit on 12/23/22.
//

import UIKit

protocol TappableLabelDelegate: AnyObject {
    func didTapLink()
}

/**
 A label where underlined portions of the text are tappable.
 */
class TappableLabel: UILabel {
    weak var delegate: TappableLabelDelegate?
    private var linkRange = NSRange(location: 0, length: 0)

    // MARK: - Initializers
    init(attributedStrings: [TappableLabelTextConfig]) {
        super.init(frame: .zero)

        updateLabelString(attributedStrings)
        addTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Helpers
    internal func updateLabelString(_ attributedStringConfigs: [TappableLabelTextConfig]) {
        let mutableString = NSMutableAttributedString()
        for config in attributedStringConfigs {
            let currentString = NSAttributedString(string: config.text, style: config.style)
            if config.style.isUnderlined ?? false {
                linkRange = NSRange(location: mutableString.length,
                                    length: currentString.length)
            }
            mutableString.append(currentString)
        }
        attributedText = mutableString
    }

    private func addTapGesture() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        // Only react to tap if tap was in range of link text
        if sender.didTapAttributedTextInLabel(label: self, inRange: linkRange) {
            delegate?.didTapLink()
        }
    }
}

struct TappableLabelTextConfig {
    let text: String
    let style: TextStyle
}
