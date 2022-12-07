//
//  CalloutWidgetStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 12/4/22.
//

import Foundation

/**
 Styling for Catch widgets which contain an info button.
 This includes the following widgets:
 - Callout
 - Express Checkout Callout
 - Payment Method
 */
public struct CalloutWidgetStyle {
    /// Configures the styling of text components within the widget.
    var widgetTextStyle: WidgetTextStyle?

    /// Configures the styling of the info button within the widget.
    var infoButtonStyle: TextStyle?
}
