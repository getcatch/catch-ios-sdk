//
//  PaymentMethodDemo.swift
//  Example
//
//  Created by Lucille Benoit on 11/9/22.
//

import Catch
import UIKit

class PaymentMethodDemo: WidgetDemo {

    override var components: [UIView] {
        return [label, widgetStack, disabledCheckbox]
    }

    private lazy var disabledCheckbox = Checkbox(title: Constant.disabled)

    let paymentMethod = PaymentMethod(price: 0)

    init() {
        super.init(title: Constant.paymentMethodName, widget: paymentMethod)
        disabledCheckbox.delegate = self
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }

    override func setPrice(price: Int) {
        paymentMethod.setPrice(price)
    }
}

extension PaymentMethodDemo: CheckboxDelegate {
    func didTapCheckbox(isSelected: Bool) {
        paymentMethod.disabled = isSelected
    }
}
