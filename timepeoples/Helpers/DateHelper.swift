//
//  DateHelper.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 09/04/25.
//

import SwiftUI


extension Date {
    func startOfDay(using calendar: Calendar = .current) -> Date {
        calendar.startOfDay(for: self)
    }

    func endOfDay(using calendar: Calendar = .current) -> Date {
        let start = calendar.startOfDay(for: self)
        return calendar.date(byAdding: DateComponents(day: 1, second: -1), to: start)!
    }
}


func firstDayOfCurrentMonth() -> Date {
    let calendar = Calendar.current
    let now = Date()

    let components = calendar.dateComponents([.year, .month], from: now)
    let startOfMonth = calendar.date(from: components)!
    return calendar.startOfDay(for: startOfMonth)
}

func lastDayOfCurrentMonth() -> Date {
    let calendar = Calendar.current
    let now = Date()

    let components = calendar.dateComponents([.year, .month], from: now)
    let startOfMonth = calendar.date(from: components)!
    
    let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
    let lastDayOffset = range.count - 1
    
    let lastDay = calendar.date(byAdding: .day, value: lastDayOffset, to: startOfMonth)!
    
    return calendar.date(bySettingHour: 23, minute: 59, second: 0, of: lastDay)!
}

func formatHourAndMinute(_ from: Date?) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.locale = Locale.current 
    return formatter.string(from: from ?? Date())
}

func formatShortDateTime(from: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .full
    formatter.locale = Locale.current
    return formatter.string(from: from)
}

func formatShortDateHour(from: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .short
    formatter.locale = Locale.current
    return formatter.string(from: from)
}

func formatShortDate(_ from: Date?) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.locale = Locale.current
    return formatter.string(from: from ?? Date())
}

func formatMediumDate(_ from: Date?) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.locale = Locale.current
    return formatter.string(from: from ?? Date())
}

func formatLongDate(_ from: Date?) -> String {
    
    let formatterDate = DateFormatter()
    formatterDate.locale = Locale.current
    formatterDate.setLocalizedDateFormatFromTemplate("EEEEddMMyy")
    //formatterDate.dateStyle = .medium
    
    let date = formatterDate.string(from: from ?? Date())
    
    
    return "\(date)"
}

func formatWeekDate(from: Date) -> String {
    let locale = Locale.current
    
    let formatterWeekDay = DateFormatter()
    formatterWeekDay.locale = locale
    formatterWeekDay.setLocalizedDateFormatFromTemplate("EEEE")
    let weekDay = formatterWeekDay.string(from: from)
    
    let formatterDate = DateFormatter()
    formatterDate.locale = Locale.current
    formatterDate.setLocalizedDateFormatFromTemplate("ddMMyy")
    //formatterDate.dateStyle = .medium
    
    let date = formatterDate.string(from: from)
    
    
    return "\(date) - \(weekDay)"
}

func formatDateTimeItemList(from: Date) -> String {
    let locale = Locale.current
    
    let formatterWeekDay = DateFormatter()
    formatterWeekDay.locale = locale
    formatterWeekDay.setLocalizedDateFormatFromTemplate("EEEE")
    let weekDay = formatterWeekDay.string(from: from)
    
    let formatterDate = DateFormatter()
    formatterDate.locale = Locale.current
    formatterDate.setLocalizedDateFormatFromTemplate("ddMMyy")
    //formatterDate.dateStyle = .medium
    
    let date = formatterDate.string(from: from)
    
    
    return "\(date) - \(weekDay)"
}

func dayNumberOfWeek(from: Date) -> Int? {
    return Calendar.current.dateComponents([.weekday], from: from).weekday
}

func daysLeft(_ expiresDate: Date?) -> Int {
    let now = Calendar.current.startOfDay(for: Date())
    let expires = Calendar.current.startOfDay(for: expiresDate ?? Date())

    let diff = Calendar.current.dateComponents([.day], from: now, to: expires).day ?? 0
    return diff
}

