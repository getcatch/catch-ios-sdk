//
//  UIColor+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 9/17/22.
//

import UIKit

extension UIColor {
    /// Creates a Color object using a hex string and alpha value.
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let hexValue: String = hexString.hasPrefix("#") ? String(hexString.dropFirst()) : hexString

        let scanner = Scanner(string: hexValue)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
