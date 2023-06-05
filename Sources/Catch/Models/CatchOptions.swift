//
//  CatchOptions.swift
//
//
//  Created by Lucille Benoit on 9/14/22.
//

import Foundation

/**
 An object which specifies optional configuration settings to
 control the global behavior of the Catch SDK.
 */
public struct CatchOptions {
    var theme: Theme
    let environment: Environment
    let useCatchFonts: Bool
    let globalStyleOverrides: CatchStyleConfig?

    /**
     Initializes ``CatchOptions`` to specify the optional configuration settings which
     control the global behavior of the Catch SDK.
     - Parameter theme: Specifies the default theme which determines the look and feel of widgets,
     from a set of available predesigned options. Defaults to the "light color" theme.
     - Parameter environment: The live environment should be used in production applications while
     the  sandbox environment should be used for development and testing. Defaults to sandbox.
     - Parameter useCatchFonts: Specifies if custom Catch fonts should be loaded into your application.
     Defaults to true.
     */
    public init(theme: Theme = .lightColor,
                environment: Environment = .sandbox,
                useCatchFonts: Bool = true,
                globalStyleOverrides: CatchStyleConfig? = nil) {
        self.theme = theme
        self.environment = environment
        self.useCatchFonts = useCatchFonts
        self.globalStyleOverrides = globalStyleOverrides
    }
}
