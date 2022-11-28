//
//  ViewController.swift
//  Example
//
//  Created by Lucille Benoit on 8/22/22.
//

import Catch
import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, PriceSliderDelegate {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var priceSlider = PriceSlider()

    private lazy var subviews: [UIView] = {
        return [
            calloutView,
            expressCheckoutCallout,
            paymentMethod,
            purchaseConfirmation,
            campaignLink,
            logoView
        ]
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        for subview in subviews {
            stack.addArrangedSubview(subview)
        }
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = Layout.verticalItemSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: stack.spacing, right: 0)
        return stack
    }()

    let logoView = LogoDemo()
    var calloutView = CalloutDemo()
    let expressCheckoutCallout = ExpressCheckoutCalloutDemo()
    let paymentMethod = PaymentMethodDemo()
    let purchaseConfirmation = PurchaseConfirmationDemo()
    let campaignLink = CampaignLinkDemo()

    struct Layout {
        static let verticalItemSpacing: CGFloat = Constant.demoStackSpacing
        static let margin: CGFloat = Constant.defaultMargin
    }

    override func viewDidLayoutSubviews() {
        scrollView.contentSize = stack.frame.size
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(priceSlider)
        view.addSubview(scrollView)

        view.backgroundColor = Constant.backgroundColor
        setConstraints()
        if #available(iOS 13.0, *) {
            navigationController?.overrideUserInterfaceStyle = .light
        }
        priceSlider.delegate = self
    }

    private func setConstraints() {
        priceSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            priceSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            priceSlider.heightAnchor.constraint(equalToConstant: 80),
            priceSlider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: priceSlider.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
    }

    func updatePrice(price: Int) {
        for subview in subviews {
            if let widget = subview as? WidgetDemo {
                widget.setPrice(price: price)
            }
        }
    }
}
