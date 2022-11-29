//
//  CalloutDemo.swift
//  Example
//
//  Created by Lucille Benoit on 11/9/22.
//

import Catch
import UIKit

class CalloutDemo: WidgetDemo {

    override var components: [UIView] {
        return [label, widgetStack, checkbox]
    }

    private lazy var checkbox = Checkbox(title: Constant.orPrefix)

    let calloutView = Callout(price: 0, borderStyle: .pill)

    init() {
        super.init(title: Constant.calloutName, widget: calloutView)
        calloutView.setBorderStyle(.roundedRect)
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }

    override func setPrice(price: Int) {
        calloutView.setPrice(price)
        calloutView.setTheme(.lightColor)
    }
}
