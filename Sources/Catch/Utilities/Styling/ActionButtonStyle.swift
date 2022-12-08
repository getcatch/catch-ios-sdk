//
//  ActionButtonStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 12/4/22.
//

import UIKit

/**
 The styling for action buttons found in Catch widgets.

 The following widgets contain action buttons:
 - Purchase Confirmation
 - Campaign Link
 */
public struct ActionButtonStyle {
    /// Configures the text styling for the button's title label
    var textStyle: TextStyle?

    /// Configures the button's background Color
    var backgroundColor: UIColor?

    /// Configures the button's height
    var height: CGFloat?

    /// Configures the button's corner radius
    var cornerRadius: CGFloat?

    /// Initializes an ActionButtonStyle configuration
    public init(textStyle: TextStyle? = nil,
                backgroundColor: UIColor? = nil,
                height: CGFloat? = nil,
                cornerRadius: CGFloat? = nil) {
        self.textStyle = textStyle
        self.backgroundColor = backgroundColor
        self.height = height
        self.cornerRadius = cornerRadius
    }
}
