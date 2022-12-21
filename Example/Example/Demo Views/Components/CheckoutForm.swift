//
//  CheckoutForm.swift
//  Example
//
//  Created by Lucille Benoit on 11/28/22.
//

import Catch
import UIKit

/**
Vertically stacked text fields and submit button used to open a checkout.
*/
class CheckoutForm: UIView {
    lazy var arrangedSubviews: [UIView] = [checkoutIDField, userPhoneField, userNameField, userEmailField, button]
    lazy var stack = WidgetConfigurationStack(subviews: arrangedSubviews, insets: nil)

    lazy var checkoutIDField = LabelTextField(title: Strings.checkoutID)
    lazy var userPhoneField = LabelTextField(title: Strings.prefillUserPhone)
    lazy var userNameField = LabelTextField(title: Strings.prefillUserName)
    lazy var userEmailField = LabelTextField(title: Strings.prefillUserEmail)

    lazy var button: UIButton = {
        let button = UIButton.init(frame: .zero)
        button.setTitle(Strings.openCheckout, for: .normal)
        button.backgroundColor = .systemGray2
        let inset = Constant.defaultMargin
        let buttonInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        button.setInsets(forContentPadding: buttonInsets, imageTitlePadding: 0)
        button.titleLabel?.font = Constant.buttonFont
        return button
    }()

    init() {
        super.init(frame: .zero)
        addConstrainedSubviewToView(stack)
        button.addTarget(self, action: #selector(openCheckout), for: .touchUpInside)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func openCheckout() {
        let prefill = CheckoutPrefill(
            userPhone: userPhoneField.text,
            userName: userNameField.text,
            userEmail: userEmailField.text
        )
        let options = CheckoutOptions(prefill: prefill) {
            print("Checkout was canceled")
        } onConfirm: {
            print("Checkout was confirmed")
        }

        CatchCheckout.openCheckout(
            checkoutId: checkoutIDField.text,
            options: options
        )
    }
}
