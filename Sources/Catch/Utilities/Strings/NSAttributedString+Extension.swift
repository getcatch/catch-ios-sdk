//
//  NSAttributedString+Extension.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import UIKit

extension NSAttributedString {
    convenience init(string: String, style: TextStyle? = .default) {
        let style = style ?? .default
        var attributes: [NSAttributedString.Key: Any] = [:]

        attributes[.font] = style.font
        attributes[.foregroundColor] = style.textColor

        if let lineSpacing = style.lineSpacing {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            attributes[.paragraphStyle] = paragraphStyle
        }

        if style.isUnderlined ?? false {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }

        let transformedString = style.textTransform?.transform(string) ?? string

        self.init(string: transformedString, attributes: attributes)
    }
}
