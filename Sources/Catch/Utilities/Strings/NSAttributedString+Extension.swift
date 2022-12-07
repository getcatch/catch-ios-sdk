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

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = style.lineSpacing
        attributes[.paragraphStyle] = paragraphStyle

        if style.isUnderlined {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }

        let transformedString = style.textTransform.transform(string)

        self.init(string: transformedString, attributes: attributes)
    }
}
