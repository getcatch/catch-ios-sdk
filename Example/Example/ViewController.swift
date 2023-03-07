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

    private lazy var subviews: [WidgetDemo] = [
        calloutView,
        expressCheckoutCallout,
        paymentMethod,
        purchaseConfirmation,
        campaignLink,
        logoView
    ]

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        for subview in subviews {
            stack.addArrangedSubview(subview)
        }
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setCustomSpacing(Layout.verticalItemSpacing, after: purchaseConfirmation)
        stack.setCustomSpacing(Layout.verticalItemSpacing, after: campaignLink)
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
        navigationController?.overrideUserInterfaceStyle = .light
        priceSlider.delegate = self
        addSegmentedControl()
    }

    private func setConstraints() {
        priceSlider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            priceSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            priceSlider.heightAnchor.constraint(equalToConstant: Constant.priceSliderHeight),
            priceSlider.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constant.demoStackSpacing
            ),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: priceSlider.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -stack.spacing)
        ])
    }

    private func addSegmentedControl() {
        let items = SegmentedControlItems.themes.keys
        let segment = SegmentedControlSection(title: nil, items: items)
        segment.delegate = self
        self.navigationItem.titleView = segment
    }

    func updatePrice(price: Int) {
        for subview in subviews {
            subview.setPrice(price: price)
        }
    }
}

extension ViewController: SegmentedControlDelegate {
    func didSelectItem(named key: String, sender: SegmentedControlSection) {
        if let theme = SegmentedControlItems.themes[key] {
            switch theme {
            case .lightMono, .lightColor:
                navigationController?.overrideUserInterfaceStyle = .light
            case .darkMono, .darkColor:
                navigationController?.overrideUserInterfaceStyle = .dark
            }

            for widget in subviews {
                widget.setTheme(theme: theme)
            }
        }
    }

}
