//
//  PostMessageAction.swift
//  Catch
//
//  Created by Lucille Benoit on 11/15/22.
//

import Foundation

enum PostMessageAction: String {
    case tofuListening = "CATCH_TOFU_LISTENING"
    case tofuLoad = "CATCH_TOFU_LOAD"
    case tofuReady = "CATCH_TOFU_READY"
    case tofuOpen = "CATCH_TOFU_OPEN"
    case tofuBack = "CATCH_TOFU_BACK"
    case checkoutReady = "CATCH_CHECKOUT_READY"
    case checkoutSuccess = "CATCH_CHECKOUT_SUCCESS"
    case checkoutBack = "CATCH_CHECKOUT_BACK"
    case virtualCardCheckoutData = "CATCH_VCN_CHECKOUT_DATA"
    case deviceToken = "CATCH_DEVICE_TOKEN"
}
