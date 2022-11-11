//
//  InfoButton.swift
//  Catch
//
//  Created by Lucille Benoit on 10/28/22.
//
import UIKit

/**
 An info UIButton which opens the edu modal or Catch tooltip.
 */
class InfoButton: UIButton {
    private let infoText = "ⓘ"
    private var style: NSAttributedStringStyle

    // MARK: - Initializers
    init(style: NSAttributedStringStyle = .default) {
        self.style = style
        super.init(frame: .zero)
        configureClickAction()
        configureButton()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    func setStyle(_ style: NSAttributedStringStyle) {
        self.style = style
        setButtonColors()
    }
}

// MARK: - Private Helpers
private extension InfoButton {
    func configureButton() {
        if #available(iOS 15.0, *) {
            configuration = UIButton.Configuration.plain()
        }

        setFormattedTitle(text: infoText, font: style.font)
        setInsets(forContentPadding: .zero, imageTitlePadding: 0)
        setButtonColors()
    }

    func setButtonColors() {
        tintColor = style.textColor
        layer.borderColor = style.textColor.cgColor
    }

    func configureClickAction() {
        addTarget(self, action: #selector(openInfoModal), for: .touchUpInside)
    }

    @objc func openInfoModal() {

    }

    private func setConstraints() {
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor),
            centerXAnchor.constraint(equalTo: centerXAnchor),
            centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
