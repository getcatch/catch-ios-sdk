//
//  Skeletonizable.swift
//  Catch
//
//  Created by Lucille Benoit on 9/20/22.
//

import UIKit

protocol Skeletonizable {
    func showSkeleton()
    func hideSkeleton()
}

extension Skeletonizable where Self: UIView {
    private var skeletonLayerName: String {
        return "skeletonLayer"
    }

    private var skeletonGradientName: String {
        return "skeletonGradient"
    }

    private var skeletonGradientAnimationName: String {
        return "skeletonGradientAnimation"
    }

    func showSkeleton() {
        let backgroundColor = CatchColor.gray3.cgColor
        let highlightColor = CatchColor.gray2.cgColor

        // Create solid skeleton layer to cover loading view
        let skeletonLayer = CALayer()
        skeletonLayer.backgroundColor = backgroundColor
        skeletonLayer.name = skeletonLayerName
        skeletonLayer.anchorPoint = .zero
        skeletonLayer.frame.size = UIScreen.main.bounds.size

        // Create horizontal linear gradient layer for loading animation
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [backgroundColor, highlightColor, backgroundColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = UIScreen.main.bounds
        gradientLayer.name = skeletonGradientName

        // Add overlay layers to view
        layer.mask = skeletonLayer
        layer.addSublayer(skeletonLayer)
        layer.addSublayer(gradientLayer)
        clipsToBounds = true

        // Round corners of loading view
        layer.cornerRadius = 3.0
        layer.masksToBounds = true

        // Animate gradient layer
        gradientLayer.add(gradientAnimation(), forKey: skeletonGradientAnimationName)

    }

    func hideSkeleton() {
        layer.sublayers?.removeAll {
            $0.name == skeletonLayerName || $0.name == skeletonGradientName
        }
    }

    // Creates a basic linear animation along the x-axis
    private func gradientAnimation() -> CABasicAnimation {
        let width = UIScreen.main.bounds.width

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.fromValue = -width
        animation.toValue = width
        animation.repeatCount = .infinity
        animation.autoreverses = false
        animation.fillMode = CAMediaTimingFillMode.forwards

        return animation
    }
}
