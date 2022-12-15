//
//  TooltipView.swift
//  Catch
//
//  Created by Lucille Benoit on 11/3/22.
//

import UIKit

// MARK: - TooltipDelegate
protocol TooltipDelegate: AnyObject {
    func didTapActionText()
    func didTapCloseButton()
}

// MARK: - TooltipView
/**
 Default themed tooltip view containing a close button and label with tappable text.
 */
class TooltipView: UIView {
    weak var delegate: TooltipDelegate?
    let theme: Theme
    lazy var textStyle = TextStyle(font: CatchFont.bodySmall,
                                   textColor: theme.foregroundColor,
                                   lineSpacing: UIConstant.smallSpacing)
    lazy var highlightStyle = TextStyle(font: CatchFont.linkSmall,
                                        textColor: theme.foregroundColor,
                                        isUnderlined: true)

    private var linkRange = NSRange(location: 0, length: 0)

    lazy var label = UILabel(frame: .zero)
    lazy var closeButton = UIButton(frame: .zero)

    lazy var stack: UIStackView = {
        let stack = UIStackView()

        stack.addArrangedSubview(label)
        stack.addArrangedSubview(closeButton)

        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .top
        stack.spacing = UIConstant.mediumSpacing
        configureStackInsets(stack)
        return stack
    }()

    // MARK: - Initializers

    init(text: String, actionText: String, theme: Theme = .lightColor) {
        self.theme = theme
        super.init(frame: .zero)
        backgroundColor = theme.backgroundColor
        configureLabel(text: text, actionText: actionText)
        configureButton()
        configureShadow()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Configuration
    private func configureStackInsets(_ stack: UIStackView) {
        stack.layoutMargins = UIEdgeInsets(inset: UIConstant.largeSpacing)
        stack.isLayoutMarginsRelativeArrangement = true
    }

    private func configureLabel(text: String, actionText: String) {
        let mutableString = NSMutableAttributedString()
        let textString = NSAttributedString(string: text, style: textStyle)
        let highlightString = NSAttributedString(string: "\n" + actionText, style: highlightStyle)
        mutableString.append(textString)

        linkRange = NSRange(location: mutableString.length,
                            length: highlightString.length)

        mutableString.append(highlightString)

        label.attributedText = mutableString
        label.numberOfLines = 0
        addTapGesture()
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    private func configureButton() {
        let linkIconImage = CatchAssetProvider.image(.closeIcon)?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(linkIconImage, for: .normal)
        closeButton.setTextColor(color: .black)
        closeButton.tintColor = theme.foregroundColor
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }

    private func configureShadow() {
        addShadow(offset: UIConstant.merchantCardShadowOffset,
                  color: .black,
                  radius: UIConstant.merchantCardShadowRadius,
                  opacity: UIConstant.merchantCardShadowOpacity)
        layer.cornerRadius = UIConstant.defaultCornerRadius
    }

    private func setConstraints() {
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            stack.widthAnchor.constraint(lessThanOrEqualToConstant: UIConstant.maxTooltipWidth),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: UIConstant.mediumSpacing),
            closeButton.widthAnchor.constraint(equalToConstant: UIConstant.mediumSpacing)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - View Interaction
    private func addTapGesture() {
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        label.addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        // Only react to tap if tap was in range of tappable text
        if sender.didTapAttributedTextInLabel(label: label, inRange: linkRange) {
            delegate?.didTapActionText()
        }
    }

    @objc private func didTapClose() {
        delegate?.didTapCloseButton()
    }
}
