//
//  WidgetContentQuery.swift
//  Catch
//
//  Created by Lucille Benoit on 4/17/23.
//

import Foundation

struct WidgetContentQuery: Encodable {
    let deviceToken: String?
    let excludeCartBasedRules: Bool = false
    let items: [String]?
    let orderTotal: Int?
    let useConfigurableRewards: Bool?
    let userCohorts: [String]?
}
