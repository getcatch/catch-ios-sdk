//
//  CatchColor.swift
//  Catch
//
//  Created by Lucille Benoit on 9/17/22.
//

import Foundation

internal enum CatchColor: String {
    case pinkName = "catch-pink"
    case pink2Name = "catch-pink-2"
    case greenName = "catch-green"
    case green2Name = "catch-green-2"
    case blackName = "catch-black"
    case gray1Name = "catch-gray-1"
    case gray2Name = "catch-gray-2"
    case gray3Name = "catch-gray-3"
}

extension CatchColor {
    static let pink = CatchAssetProvider.color(.pinkName) ?? .systemPink
    static let pink2 = CatchAssetProvider.color(.pink2Name) ?? .systemPink
    static let green = CatchAssetProvider.color(.greenName) ?? .green
    static let green2 = CatchAssetProvider.color(.green2Name) ?? .green
    static let black = CatchAssetProvider.color(.blackName) ?? .black
    static let gray1 = CatchAssetProvider.color(.gray1Name) ?? .white
    static let gray2 = CatchAssetProvider.color(.gray2Name) ?? .lightGray
    static let gray3 = CatchAssetProvider.color(.gray3Name) ?? .lightGray
}
