//
//  CatchLogo.swift
//
//
//  Created by Lucille Benoit on 8/22/22.
//

import UIKit

/// The CatchLogo view displays Catch's logo.
public class CatchLogo: UIView, ThemeResponding {

    internal var themeManager: ThemeManager

    internal var theme: Theme {
        didSet {
            configureImageView()
        }
    }

    private var imageView = UIImageView(frame: .zero)
    private var image: UIImage?

    // MARK: - Initializers

    /**
     Initializes a new catch logo view with one of Catch's supported color themes.
     If no theme is provided, the default will be used.
     - Parameter theme: The Catch color theme.
     */
    public init(theme: Theme? = nil) {
        self.themeManager = ThemeManager(theme)
        self.theme = theme ?? .lightColor
        super.init(frame: .zero)
        configureImageView()
        themeManager.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    public func setTheme(_ theme: Theme) {
        themeManager.updateTheme(theme)
    }

    // MARK: - Private Helpers
    private func configureImageView() {
        imageView.image = theme.logoImage
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        setImageViewConstraints()
        imageView.sizeToFit()
    }

    private func setImageViewConstraints() {
        guard let image = imageView.image else { return }
        let ratio = image.size.height / image.size.width
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
