//
//  String+Extension.swift
//  
//
//  Created by Lucille Benoit on 10/6/22.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, bundle: CatchResources.resourceBundle, comment: "\(self)_comment")
    }

    func localized(_ args: CVarArg...) -> String {
      return String(format: localized, args)
    }
}
