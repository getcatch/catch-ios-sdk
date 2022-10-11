//
//  RemoteImageView.swift
//  
//
//  Created by Lucille Benoit on 10/4/22.
//

import UIKit

internal let imageCache = ImageCache()

/**
An Image view with the ability to download and cache images from a URL.
 */
class RemoteImageView: UIImageView {

    /**
        Sets the imageView's image with a url.
        - Parameter url: The string representing the url where the image will be downloaded from.
        - Parameter placeholderColor: The background color to display while the image is loading.
     */
    func setImage(url: String, placeholderColor: UIColor? = nil) {
        if let placeholderColor = placeholderColor {
            backgroundColor = placeholderColor
        }
        imageCache.loadImage(from: url) { [weak self] loadedImage in
            self?.image = loadedImage
        }
    }

}
