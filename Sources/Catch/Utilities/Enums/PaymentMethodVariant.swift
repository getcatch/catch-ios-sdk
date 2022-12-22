//
//  PaymentMethodVariant.swift
//  Catch
//
//  Created by Lucille Benoit on 11/4/22.
//

import Foundation

/**
 Represents the configuration variants of the ``PaymentMethod`` widget.
 */
public enum PaymentMethodVariant {
    /// The default configuration which includes the Catch logo, filler text and reward text.
    case standard

    /// The compact variant removes the Catch logo from the default configuration.
    case compact

    /// The logoCompact variant removes the filler text from the default configuration.
    case logoCompact
}
