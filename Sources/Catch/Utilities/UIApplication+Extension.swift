//
//  UIApplication+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 11/22/22.
//

import UIKit

extension UIApplication {
    static func topViewController() -> UIViewController? {
        guard var top = shared.keyWindow?.rootViewController else {
            return nil
        }
        while let next = top.presentedViewController {
            top = next
        }
        return top
    }
}
