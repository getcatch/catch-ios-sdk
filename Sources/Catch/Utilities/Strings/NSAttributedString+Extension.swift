//
//  NSAttributedString+Extension.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import UIKit

extension NSAttributedString {
    convenience init(string: String, style: TextStyle? = nil) {
        let style = style ?? TextStyle()
        var attributes: [NSAttributedString.Key: Any] = [:]

        attributes[.font] = style.font
        attributes[.foregroundColor] = style.textColor

        if let lineSpacing = style.lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributes[.paragraphStyle] = paragraphStyle
        }

        if let letterSpacing = style.letterSpacing {
            attributes[.kern] = letterSpacing
        }

        if style.isUnderlined ?? false {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }

        let transformedString = style.textTransform?.transform(string) ?? string

        self.init(string: transformedString, attributes: attributes)
    }
}
