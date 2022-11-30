//
//  BorderSegmentedControl.swift
//  Example
//
//  Created by Lucille Benoit on 11/9/22.
//

import Catch
import Foundation

/**
Segmented control view which displays the available border styles.
*/
class BorderSegmentedControl: SegmentedControlSection {
    let restrictOptions: Bool

    var currentlySelectedStyle: BorderStyle {
        let key = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        if let key = key, let style = SegmentedControlItems.borderStyles(restricted: restrictOptions)[key] {
            return style
        }
        return .roundedRect
    }

    init(restrictOptions: Bool = false) {
        self.restrictOptions = restrictOptions
        let options = SegmentedControlItems.borderStyles(restricted: restrictOptions).keys
        super.init(title: Strings.borderStyle, items: options)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
