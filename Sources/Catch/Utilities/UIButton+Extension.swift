//
//  UIButton+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 10/27/22.
//

import UIKit

extension UIButton {
    /**
     Sets the padding around the button content and the padding between the title and image.
     Works for all iOS versions.
     */
    func setInsets(forContentPadding contentPadding: UIEdgeInsets, imageTitlePadding: CGFloat) {
        if #available(iOS 15.0, *) {
            configuration?.contentInsets = NSDirectionalEdgeInsets(top: contentPadding.top,
                                                                   leading: contentPadding.left,
                                                                   bottom: contentPadding.bottom,
                                                                   trailing: contentPadding.right)
            configuration?.imagePadding = imageTitlePadding
        } else {
            // Fallback on earlier versions
            contentEdgeInsets = UIEdgeInsets(
                top: contentPadding.top,
                left: contentPadding.left + imageTitlePadding,
                bottom: contentPadding.bottom,
                right: contentPadding.left
            )
            titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -imageTitlePadding,
                bottom: 0,
                right: imageTitlePadding
            )
        }
    }

    /**
     Sets the text and font for the title label.
     Works for all iOS versions.
     */
    func setFormattedTitle(text: String, font: UIFont) {
        if #available(iOS 15, *) {
            var container = AttributeContainer()
            container.font = font
            configuration?.attributedTitle = AttributedString(text, attributes: container)
        } else {
            setTitle(text, for: .normal)
            titleLabel?.font = font
        }

    }

    /**
     Sets the text color for the title label.
     Works for all iOS versions.
     */
    func setTextColor(color: UIColor) {
        if #available(iOS 15.0, *) {
            configuration?.attributedTitle?.foregroundColor = color
        } else {
            titleLabel?.textColor = color
        }
    }

    /**
     Sets the right-hand image for the button.
     Works for all iOS versions.
     */
    func setRightImage(image: UIImage?) {
        guard let image = image else { return }

        if #available(iOS 15, *) {
            configuration?.image = image
            configuration?.imagePlacement = .trailing

        } else {
            setImage(image, for: .normal)
            semanticContentAttribute = .forceRightToLeft
        }
    }
}
