//
//  UIApplication+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 11/22/22.
//

import UIKit

extension UIApplication {
    static func topViewController() -> UIViewController? {
        var topViewController: UIViewController?

        if #available(iOS 13.0, *) {
            let keyWindow = shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .last { $0.isKeyWindow }
            topViewController = keyWindow?.rootViewController
        } else {
            topViewController = shared.keyWindow?.rootViewController
        }

        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }

        return topViewController
    }
}
