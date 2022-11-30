//
//  ExpressCheckoutCalloutDemo.swift
//  Example
//
//  Created by Lucille Benoit on 11/9/22.
//

import Catch
import UIKit

class ExpressCheckoutCalloutDemo: WidgetDemo {
    private lazy var borderStyleConfig = BorderSegmentedControl()
    private lazy var configurationStack = WidgetConfigurationStack(subviews: [borderStyleConfig])

    override var components: [UIView] {
        return [label, widgetStack, configurationStack]
    }

    let expressCheckoutCallout = ExpressCheckoutCallout(price: 0)

    init() {
        super.init(title: Strings.expressCheckoutCalloutName, widget: expressCheckoutCallout)
        borderStyleConfig.delegate = self
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }

}

extension ExpressCheckoutCalloutDemo: SegmentedControlDelegate {
    func didSelectItem(named key: String, sender: SegmentedControlSection) {
        expressCheckoutCallout.setBorderStyle(borderStyleConfig.currentlySelectedStyle)
    }
}
