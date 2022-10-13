//
//  NSAttributedStringStyle.swift
//  
//
//  Created by Lucille Benoit on 10/12/22.
//

import UIKit

struct NSAttributedStringStyle {
    var font: UIFont = CatchFont.bodySmall
    var textColor: UIColor = Theme.lightColor.foregroundColor
    var textTransform: TextTransform = .none
    var lineSpacing: CGFloat? = nil
    var isTappable: Bool = false

    static var `default`: NSAttributedStringStyle {
        return NSAttributedStringStyle()
    }
}
