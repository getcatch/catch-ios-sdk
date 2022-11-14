//
//  BaseWidgetConfiguring.swift
//  Catch
//
//  Created by Lucille Benoit on 11/4/22.
//

import UIKit

struct BaseWidgetConfig {
    var price: Int?
    var theme: Theme?
    var borderConfig: BorderConfig = BorderConfig()
    var items: [Item]?
    var userCohorts: [String]?
    var earnRedeemLabelConfig: EarnRedeemLabelType = .expressCheckoutCallout
}

struct BorderConfig {
    var insets: UIEdgeInsets = .zero
    var style: BorderStyle?
}
