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

        layer.masksToBounds = true
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
        setAttributedString(title: title)
        setColors()
        layer.cornerRadius = style.cornerRadius ?? UIConstant.defaultCornerRadius
    }

    func updateConfiguration(text: String, url: URL? = nil) {
        self.title = text
        self.url = url

        setAttributedString(title: title)
        setColors()
    }
}

// MARK: - Private Helpers

private extension ExternalLinkButton {
    func configureButton() {
        if #available(iOS 15.0, *) {
            configuration = UIButton.Configuration.filled()

            /// Set the background corner radius to 0 so that the background respects whichever corner radius is set on the layer.
            configuration?.background.cornerRadius = 0
            configuration?.cornerStyle = .fixed
        }

        let linkIconImage = CatchAssetProvider.image(.linkIcon)?.withRenderingMode(.alwaysTemplate)
        setRightImage(image: linkIconImage)

        let insets = UIEdgeInsets(inset: UIConstant.largeSpacing)
        setInsets(forContentPadding: insets, imageTitlePadding: UIConstant.mediumSpacing)
    }

    func setColors() {
        setBackgroundColor(color: style.backgroundColor ?? .clear)
        if let color = style.textStyle?.textColor {
            setTextColor(color: color)
            setTintColor(color: color)
        }
    }

    func setAttributedString(title: String) {
        setFormattedTitle(attributedString: NSAttributedString(string: title, style: style.textStyle))
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
