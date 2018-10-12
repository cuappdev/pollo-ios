//
//  Date+Shared.swift
//  Clicker
//
//  Created by Matthew Coufal on 10/12/18.
//  Copyright © 2018 CornellAppDev. All rights reserved.
//

import UIKit

extension Date {
    
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
}
