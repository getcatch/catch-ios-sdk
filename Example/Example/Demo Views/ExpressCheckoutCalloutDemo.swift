//
//  ExpressCheckoutCalloutDemo.swift
//  Example
//
//  Created by Lucille Benoit on 11/9/22.
//

import Catch
import UIKit

class ExpressCheckoutCalloutDemo: WidgetDemo {

    let expressCheckoutCallout = ExpressCheckoutCallout(price: 0)

    init() {
        super.init(title: Strings.expressCheckoutCalloutName, widget: expressCheckoutCallout)
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }

    override func setPrice(price: Int) {
        expressCheckoutCallout.setPrice(price)
    }
}
