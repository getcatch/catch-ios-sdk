//
//  ImageCache.swift
//  
//
//  Created by Lucille Benoit on 10/4/22.
//

import UIKit

class ImageCache {
    private var cache = NSCache<NSString, UIImage>()

    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = get(key: url) {
            completion(cachedImage)
            return
        }
        imageFromRemoteUrl(url: url) { loadedImage in
            completion(loadedImage)
        }
    }

    private func imageFromRemoteUrl(url: String, completion: @escaping (UIImage?) -> Void) {

        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageURL, completionHandler: { [weak self](data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    guard let remoteImage = UIImage(data: data) else {
                        completion(nil)
                        return
                    }

                    self?.set(key: url, image: remoteImage)
                    completion(remoteImage)
                }
            }
            }).resume()
    }

    private func get(key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }

    private func set(key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
