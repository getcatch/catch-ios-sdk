//
//  UIEdgeInsets+Extension.swift
//  
//
//  Created by Lucille Benoit on 10/28/22.
//

import Foundation

extension UIEdgeInsets {
    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}
