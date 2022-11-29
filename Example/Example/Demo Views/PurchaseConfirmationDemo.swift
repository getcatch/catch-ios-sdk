//
//  PurchaseConfirmationDemo.swift
//  Example
//
//  Created by Lucille Benoit on 11/9/22.
//

import Catch
import UIKit

class PurchaseConfirmationDemo: WidgetDemo {

    let purchaseConfirmation = PurchaseConfirmation(earned: Constant.initialEarnedAmount)

    init() {
        super.init(title: Strings.purchaseConfirmationName, widget: purchaseConfirmation)
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }

    override func setPrice(price: Int) {
        purchaseConfirmation.setEarnedAmount(price)
    }
}
