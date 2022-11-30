//
//  BorderSegmentedControl.swift
//  Example
//
//  Created by Lucille Benoit on 11/9/22.
//

import Foundation

/**
Segmented control view which displays the available border styles.
*/
class BorderSegmentedControl: SegmentedControlSection {

    init(restrictOptions: Bool = false) {
        let options = SegmentedControlItems.borderStyles(restricted: restrictOptions).keys
        super.init(title: Strings.borderStyle, items: options)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
