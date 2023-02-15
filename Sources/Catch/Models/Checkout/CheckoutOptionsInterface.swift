//
//  CheckoutOptionsInterface.swift
//  Catch
//
//  Created by Lucille Benoit on 2/14/23.
//

import Foundation

protocol CheckoutOptionsInterface {
    var prefill: CheckoutPrefill? { get }
    var onCancel: (() -> Void)? { get }
    var onConfirmCallback: (() -> Void)? { get }
    var virtualCardOnConfirmCallback: ((CardDetails?) -> Void)? { get }
}

extension CheckoutOptionsInterface {
    /// Provide default implementations so that structs conforming to this protocol
    /// can implement either onConfirmCallback or virtualCardOnConfirmCallback
    var onConfirmCallback: (() -> Void)? {
        return nil
    }
    var virtualCardOnConfirmCallback: ((CardDetails?) -> Void)? {
        return nil
    }
}
