//
//  Date + Extensions.swift
//  MomoApp
//
//  Created by Priscilla Ip on 2020-09-17.
//

import SwiftUI

// MARK: - Date Formatter

let dateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E, MMM d"
    return formatter
}()

extension Date {
    static func getDates(forLastNDays nDays: Int) -> [String] {
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .weekOfYear, value: 1, to: Date())!
        var date = calendar.startOfDay(for: sevenDaysAgo)

        var arrDates = [String]()
        for _ in 1 ... nDays {
            date = calendar.date(byAdding: .day, value: 1, to: date)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        return arrDates
    }
    
    // MARK: - Extracting components
    
    func component(_ component:DateComponentType) -> Int? {
        let components = Date.components(self)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .nthWeekday:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }
    
    // MARK: - Internal Components
    
    internal static func componentFlags() -> Set<Calendar.Component> { return [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday, Calendar.Component.weekdayOrdinal, Calendar.Component.weekOfYear] }
    internal static func components(_ fromDate: Date) -> DateComponents {
        return Calendar.current.dateComponents(Date.componentFlags(), from: fromDate)
    }
}

// MARK: - Public Enums

// The date components available to be retrieved or modified
public enum DateComponentType {
    case second, minute, hour, day, weekday, nthWeekday, week, month, year
}
