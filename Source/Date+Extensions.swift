//
//  Date+Extensions.swift
//  EasyDatePicker
//
//  Created by 李杰 on 2019/3/11.
//  Copyright © 2019 李杰. All rights reserved.
//

import UIKit

extension Date {
    func currentDate(_ identifier: String = "zh") -> Date {
        let date = Date()
        let zone = TimeZone(identifier: identifier)
        let interval: NSInteger = zone?.secondsFromGMT(for: date) ?? 0
        let now = date.addingTimeInterval(TimeInterval(interval))
        return now
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        let component = calendar.component(.year, from: currentDate())
        return component
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        let component = calendar.component(.month, from: currentDate())
        return component
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        let component = calendar.component(.day, from: currentDate())
        return component
    }
    
    func dateFromString(_ str: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: str)
        return date
    }
    
    func getCountOfDaysInMonth(year:Int, month:Int) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: String(year)+"-"+String(month))
        let calendar = Calendar.current
        let range = (calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date!)
        return (range?.length)!
    }

}
