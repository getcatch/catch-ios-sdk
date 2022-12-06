//
//  CalloutDemo.swift
//  Example
//
//  Created by Lucille Benoit on 11/9/22.
//

import Catch
import UIKit

class CalloutDemo: WidgetDemo {
    private lazy var borderStyleConfig = BorderSegmentedControl()
    private lazy var checkbox = Checkbox(title: Strings.orPrefix)
    private lazy var configurationStack = WidgetConfigurationStack(subviews: [borderStyleConfig, checkbox])

    override var components: [UIView] {
        return [label, widgetStack, configurationStack]
    }

    var
    calloutView = Callout(price: 0, borderStyle: .pill)

    init() {
        super.init(title: Strings.calloutName, widget: calloutView)
        calloutView.setBorderStyle(.roundedRect)
        checkbox.delegate = self
        borderStyleConfig.delegate = self
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }

}

extension CalloutDemo: CheckboxDelegate {
    func didTapCheckbox(isSelected: Bool) {
        let newCallout = Callout(
            price: price,
            borderStyle: borderStyleConfig.currentlySelectedStyle,
            orPrefix: isSelected,
            theme: theme
        )
        updateWidget(newCallout)
        calloutView = newCallout
    }

}

extension CalloutDemo: SegmentedControlDelegate {
    func didSelectItem(named key: String, sender: SegmentedControlSection) {
        calloutView.setBorderStyle(borderStyleConfig.currentlySelectedStyle)
    }
}
