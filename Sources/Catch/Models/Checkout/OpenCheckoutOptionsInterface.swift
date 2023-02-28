//
//  OpenCheckoutOptionsInterface.swift
//  Catch
//
//  Created by Lucille Benoit on 2/14/23.
//

import Foundation

protocol OpenCheckoutOptionsInterface {
    var prefill: CheckoutPrefill? { get }
    var onCancel: (() -> Void)? { get }
}
