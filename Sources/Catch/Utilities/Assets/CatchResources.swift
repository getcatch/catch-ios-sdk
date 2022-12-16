//
//  CatchResources.swift
//  
//
//  Created by Lucille Benoit on 9/2/22.
//

import Foundation

final class CatchResources {
    static let resourceBundle: Bundle = {
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: CatchResources.self).resourceURL
        ]

        let bundleName = "Catch_Catch"

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        // Return whatever bundle this code is in as a last resort.
        return Bundle(for: CatchResources.self)
    }()
}
