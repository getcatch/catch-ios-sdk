//
//  PaymentMethodDemo.swift
//  Example
//
//  Created by Lucille Benoit on 11/9/22.
//

import Catch
import UIKit

class PaymentMethodDemo: WidgetDemo {
    private let variantItems: [String] = [Strings.default, Strings.compact, Strings.logoCompact]

    override var components: [UIView] {
        return [label, widgetStack, configurationStack]
    }

    private lazy var disabledCheckbox = Checkbox(title: Strings.disabled)
    private lazy var variantControl = SegmentedControlSection(title: Strings.variant, items: variantItems)

    private lazy var configurationStack = WidgetConfigurationStack(subviews: [
        variantControl,
        disabledCheckbox,
        checkoutForm
    ])

    private lazy var checkoutForm = CheckoutForm()

    var paymentMethod = PaymentMethod(price: 0)

    init() {
        super.init(title: Strings.paymentMethodName, widget: paymentMethod)
        disabledCheckbox.delegate = self
        variantControl.delegate = self
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }
}

extension PaymentMethodDemo: CheckboxDelegate {
    func didTapCheckbox(isSelected: Bool) {
        paymentMethod.disabled = isSelected
    }
}

extension PaymentMethodDemo: SegmentedControlDelegate {
    func didSelectItem(named key: String, sender: SegmentedControlSection) {
        guard let variant = SegmentedControlItems.variants[key] else { return }
        let newPaymentMethod = PaymentMethod(
            price: price,
            disabled: paymentMethod.disabled,
            theme: theme,
            variant: variant
        )
        updateWidget(newPaymentMethod)
        paymentMethod = newPaymentMethod
    }

}
