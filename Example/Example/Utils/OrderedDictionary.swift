//
//  OrderedDictionary.swift
//  Example
//
//  Created by Lucille Benoit on 11/19/22.
//

import Foundation

/**
Simple ordered dictionary to keep track of segmented control titles and their related objects.
*/
struct OrderedDictionary<Tk: Hashable, Tv> {
    var keys: [Tk] = []
    var values: [Tk: Tv] = [:]

    init() {}

    subscript(key: Tk) -> Tv? {
        get {
            return self.values[key]
        }
        set(newValue) {
            guard let newValue = newValue else {
                values.removeValue(forKey: key)
                keys = keys.filter { $0 != key }
                return
            }

            let oldValue = values.updateValue(newValue, forKey: key)
            if oldValue == nil {
                keys.append(key)
            }
        }
    }
}
