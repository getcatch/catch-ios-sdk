//
//  ExternalLinkButton.swift
//  Catch
//
//  Created by Lucille Benoit on 10/27/22.
//

import UIKit

/**
 A styled UIButton which opens the specified url.
 */
class ExternalLinkButton: UIButton {

    private var url: URL?
    private var title: String
    private var style: ActionButtonStyle

    // MARK: - Initializers

    init(title: String, url: URL?, style: ActionButtonStyle) {
        self.title = title
        self.url = url
        self.style = style
        super.init(frame: .zero)

        configureButton()
        setColors()
        configureClickAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func setStyle(style: ActionButtonStyle) {
        self.style = style
        setColors()
        setFormattedTitle(text: title, font: style.textStyle?.font)
    }

    func updateConfiguration(text: String, url: URL? = nil) {
        self.title = text
        self.url = url
        setFormattedTitle(text: text, font: style.textStyle?.font)
    }
}

// MARK: - Private Helpers

private extension ExternalLinkButton {
    func configureButton() {
        layer.cornerRadius = style.cornerRadius ?? UIConstant.defaultCornerRadius
        layer.masksToBounds = true

        if #available(iOS 15.0, *) {
            configuration = UIButton.Configuration.filled()
        }

        let linkIconImage = CatchAssetProvider.image(.linkIcon)?.withRenderingMode(.alwaysTemplate)
        setRightImage(image: linkIconImage)

        let insets = UIEdgeInsets(inset: UIConstant.largeSpacing)
        setInsets(forContentPadding: insets, imageTitlePadding: UIConstant.mediumSpacing)
    }

    func setColors() {
        tintColor = style.backgroundColor
        if let color = style.textStyle?.textColor {
            setTextColor(color: color)
        }
    }

    func configureClickAction() {
        addTarget(self, action: #selector(openLink), for: .touchUpInside)
    }

    @objc func openLink() {
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
}
