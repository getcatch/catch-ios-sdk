//
//  TooltipPresenting.swift
//  Catch
//
//  Created by Lucille Benoit on 11/3/22.
//

import UIKit

/**
 Protocol for views or controllers which will present tooltip views.
 Classes conforming to this protocol must also override adaptivePresentationStyle
 to return .none in order to force the popover style.
 */
protocol TooltipPresenting: TooltipDelegate, UIPopoverPresentationControllerDelegate {
    var tooltipController: UIViewController? { get set }
}

extension TooltipPresenting {
    func removeTooltipView(completion: (() -> Void)? = nil) {
        tooltipController?.dismiss(animated: true, completion: completion)
    }

    func showTooltip(sourceView: UIView, text: String, highlightText: String, theme: Theme) {
        let controller = TooltipViewController(text: text, highlightText: highlightText, theme: theme, delegate: self)
        tooltipController = controller

        // set the presentation style and preferred size
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        controller.preferredContentSize = controller.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        // set up the popover presentation controller
        controller.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        controller.popoverPresentationController?.sourceView = sourceView
        controller.popoverPresentationController?.sourceRect = sourceView.bounds

        // present the popover controller
        let presentingController = UIApplication.topViewController()
        controller.popoverPresentationController?.delegate = self
        presentingController?.present(controller, animated: true, completion: nil)
    }
}
