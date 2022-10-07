//
//  CatchAssetProvider.swift
//  
//
//  Created by Lucille Benoit on 9/2/22.
//

import UIKit

internal class CatchAssetProvider {

    internal static func image(_ image: CatchImage) -> UIImage? {
        return UIImage(named: image.rawValue, in: CatchResources.resourceBundle, compatibleWith: nil)
    }

    internal static func color(_ color: CatchColor) -> UIColor? {
        return UIColor(named: color.rawValue, in: CatchResources.resourceBundle, compatibleWith: nil)
    }

}

internal enum CatchColor: String {
    case catchPink = "catch-pink"
    case catchBlack = "catch-black"
    case catchGray1 = "catch-gray-1"
    case catchGray2 = "catch-gray-2"
    case catchGray3 = "catch-gray-3"
}

internal enum CatchImage: String {
    case logoDark = "logo-dark"
    case logoMonoDark = "logo-mono-dark"
    case logoMonoWhite = "logo-mono-white"
    case logoWhite = "logo-white"
}
