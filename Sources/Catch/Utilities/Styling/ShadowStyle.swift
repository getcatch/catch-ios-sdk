//
//  ShadowStyle.swift
//  Catch
//
//  Created by Lucille Benoit on 12/13/22.
//

import Foundation
import UIKit

public struct ShadowStyle {
    /// The offset (in points) of the layer's shadow
    var offset: CGSize

    /// The color of the layer's shadow
    var color: UIColor

    /// The blur radius (in points) used to render the layer's shadow.
    var radius: CGFloat

    /// The opacity of the layer's shadow.
    var opacity: Float

    /// Initializes a ShadowStyle configuration.
    public init(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        self.offset = offset
        self.color = color
        self.radius = radius
        self.opacity = opacity
    }
}
