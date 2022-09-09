//
//  CatchLogo.swift
//
//
//  Created by Lucille Benoit on 8/22/22.
//

import UIKit

/// The CatchLogo view displays Catch's logo.
public class CatchLogo: UIView {

    public var theme: Theme = .lightColor {
        didSet { configureImageView() }
    }

    private var imageView = UIImageView(frame: .zero)
    private var image: UIImage?

    /**
     Initializes a new catch logo view with one of Catch's supported color themes.
     If no theme is provided, the default will be used.
     - Parameter theme: The Catch color theme.
     */
    public init(theme: Theme = .lightColor) {
        self.theme = theme
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        configureImageView()
    }

    private func configureImageView() {
        imageView.image = theme.logoImage
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        setImageViewConstraints()
    }

    private func setImageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }

}
