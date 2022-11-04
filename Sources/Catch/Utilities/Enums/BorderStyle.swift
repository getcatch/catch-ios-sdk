//
//  BorderStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 9/7/22.
//

import UIKit

public enum BorderStyle {
    /// Renders a border with slightly rounded rect corners.
    case roundedRect
    /// Renders a border with fully rounded corners.
    case pill
    /// Renders a border with square corners.
    case square
    /// Renders widgets with no borders and no padding around the internal content.
    case none

    /**
     Calculates the cornerRadius for the border style based on the view height
     and whether or not the widget is one of the larger-height widgets.
     - Parameter viewHeight: The height of the widget.
     - Parameter isLargeElement: Should be true for PurchaseConfirmation
     and CampaignLink widgets. Defaults to false.
     */
    internal func cornerRadius(for viewHeight: CGFloat) -> CGFloat? {
        let isLargeElement = viewHeight > UIConstant.minViewHeightForLargeElement
        switch self {
        case .roundedRect:
            return isLargeElement
            ? UIConstant.largeCornerRadius
            : UIConstant.defaultCornerRadius
        case .pill:
            return viewHeight / 2
        case .square:
            return 0
        case .none:
            return nil
        }
    }
}
