//
//  Date+Extension.swift
//  Catch
//
//  Created by Lucille Benoit on 11/3/22.
//

import Foundation

extension Date {
    func byAdding(days: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.day = days
        return Calendar.current.date(byAdding: dateComponent, to: self)
    }
}
