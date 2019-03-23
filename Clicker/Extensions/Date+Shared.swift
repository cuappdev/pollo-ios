//
//  Date+Shared.swift
//  Clicker
//
//  Created by Matthew Coufal on 10/12/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

extension Date {

    private var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    private var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    private var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    /// String value of seconds since 1970
    var secondsString: String {
        return "\(Int(self.timeIntervalSince1970))"
    }

    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }

    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    func toLocalTime() -> Date {
        let seconds = TimeInterval(TimeZone.current.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    /// Checks whether or not two dates share the same month, day, and year.
    func isSameDay(as date: Date) -> Bool {
        return month == date.month && day == date.day && year == date.year
    }
}
