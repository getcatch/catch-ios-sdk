//
//  LogoDemo.swift
//  Example
//
//  Created by Lucille Benoit on 11/9/22.
//

import Catch
import UIKit

class LogoDemo: WidgetDemo {

    let logo = CatchLogo()

    init() {
        super.init(title: Constant.logoName, widget: logo)
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }
}
