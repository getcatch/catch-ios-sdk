//
//  CatchFontLoader.swift
//  
//
//  Created by Lucille Benoit on 9/16/22.
//

import Foundation
import CoreText

struct CatchFontLoader {
    static let fontPath = "Fonts/"
    static let fontExtension = "ttf"

    static func registerFonts() {
        CatchFont.allFontNames.forEach {
            registerFont(fontName: $0)
        }
    }

    private static func registerFont(fontName: String) {
        guard let fontURL = CatchResources.resourceBundle.url(
            forResource: fontPath+fontName,
            withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }

        var error: Unmanaged<CFError>?

        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
