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
 - ``PurchaseConfirmation``
 - ``CampaignLink``
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

    /// Configures the button's shadow
    var shadowStyle: ShadowStyle?

    /**
     Initializes an ``ActionButtonStyle`` configuration.
     - Parameter textStyle: The text styling for the button's title label (see ``TextStyle``).
     - Parameter backgroundColor: The button's background color.
     - Parameter height: The button's height.
     - Parameter cornerRadius: The corner radius of the button's corners.
     - Parameter shadowStyle: The drop shadow styling for the button (see ``ShadowStyle``).
     */
    public init(textStyle: TextStyle? = nil,
                backgroundColor: UIColor? = nil,
                height: CGFloat? = nil,
                cornerRadius: CGFloat? = nil,
                shadowStyle: ShadowStyle? = nil) {
        self.textStyle = textStyle
        self.backgroundColor = backgroundColor
        self.height = height
        self.cornerRadius = cornerRadius
        self.shadowStyle = shadowStyle
    }

    static func resolved(_ buttonStyle: ActionButtonStyle?,
                         withOverrides overrides: ActionButtonStyle?) -> ActionButtonStyle? {
        ActionButtonStyle(textStyle: TextStyle.resolved(buttonStyle?.textStyle, withOverrides: overrides?.textStyle),
                          backgroundColor: overrides?.backgroundColor ?? buttonStyle?.backgroundColor,
                          height: overrides?.height ?? buttonStyle?.height,
                          cornerRadius: overrides?.cornerRadius ?? buttonStyle?.cornerRadius)
    }

    static func defaults(_ theme: Theme) -> ActionButtonStyle {
        let textStyle = TextStyle(font: CatchFont.buttonLabel, textColor: theme.buttonTextColor)
        let buttonStyle = ActionButtonStyle(textStyle: textStyle,
                                            backgroundColor: theme.accentColor,
                                            cornerRadius: UIConstant.defaultCornerRadius)
        return buttonStyle
    }
}
