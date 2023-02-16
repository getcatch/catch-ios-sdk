//
//  OpenCheckoutOptions.swift
//  Catch
//
//  Created by Lucille Benoit on 2/14/23.
//

import Foundation

protocol OpenCheckoutOptions {
    var prefill: CheckoutPrefill? { get }
    var onCancel: (() -> Void)? { get }
}
