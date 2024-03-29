//
//  CatchLogo.swift
//
//
//  Created by Lucille Benoit on 8/22/22.
//

import UIKit

/**
 A view which displays Catch's logo.

 Can be displayed in one of four color themes.
 */
public class CatchLogo: UIView, NotificationResponding {

    internal var theme: Theme {
        didSet {
            configureImageView()
        }
    }

    private var imageView = UIImageView(frame: .zero)
    private var image: UIImage?

    override public var intrinsicContentSize: CGSize {
        guard let image = imageView.image else { return .zero }
        let ratio = image.size.width / image.size.height
        let width = bounds.height * ratio
        return CGSize(width: width, height: bounds.height)
    }

    // MARK: - Initializers

    /**
     Initializes a ``CatchLogo`` view with one of Catch's supported color themes.
     If no theme is provided, the default light color theme will be used.
     - Parameter theme: The Catch color theme. See ``Theme`` for all theme options.
     */
    public init(theme: Theme? = nil) {
        self.theme = theme ?? Catch.getTheme()
        super.init(frame: .zero)
        configureImageView()
        // Only subscribe to global theme updates if no local theme has been set
        if theme == nil {
            subscribeToGlobalThemeUpdates()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    /**
     Sets the local theme for the widget.
     - Parameter theme: The Catch color theme.
     */
    public func setTheme(_ theme: Theme) {
        unsubscribeFromNotifications()
        self.theme = theme
    }

    // MARK: - Private Helpers
    internal func didReceiveNotification(_ notification: Notification) {
        if let theme = notification.object as? Theme {
            self.theme = theme
        }
    }

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
