//
//  Date + Extensions.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-17.
//

import SwiftUI

// MARK: - Date Formatter

extension DateFormatter {
    /// Sunday, Nov 8
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
}

extension Date {
    enum DateFormat: String {
        case short = "EEEE, MMM d"
        case weekday = "eeeee" // Monday: "M"
        case day = "d"
    }
    
    func toString(withFormat format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }

    func getWeekday() -> String {
        return self.toString(withFormat: .weekday)
    }

    func getDay() -> String {
        let dayString = self.toString(withFormat: .day)
        return dayString
    }
    
    func getDates(forLastNDays nDays: Int) -> [String] {
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
        var date = calendar.startOfDay(for: sevenDaysAgo)
        
        var arrDates = [String]()
        for _ in 1 ... nDays {
            date = calendar.date(byAdding: .day, value: 1, to: date)!
            let dateString = date.toString(withFormat: .day)
            arrDates.append(dateString)
        }
        return arrDates
    }
    
    func getDaysInCurrentMonth(date: Date) -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        let numOfDays = range.count
        return numOfDays
    }
    
    func createDate(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(
            calendar: Calendar.current,
            //timeZone: TimeZone?,
            //era: Int?,
            year: year,
            month: month,
            day: day
            //hour: Int?,
            //minute: Int?,
            //second: Int?,
            //nanosecond: Int?,
            //weekday: Int?,
            //weekdayOrdinal: Int?,
            //quarter: Int?,
            //weekOfMonth: Int?,
            //weekOfYear: Int?,
            //yearForWeekOfYear: Int?)
        )
        return Calendar.current.date(from: components)!
    }
}
