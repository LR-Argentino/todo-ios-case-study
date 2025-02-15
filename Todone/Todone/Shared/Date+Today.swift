//
//  Date+Today.swift
//  Todone
//
//  Created by Luca Argentino on 26.01.2025.
//

import Foundation

public extension Date {
    var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)

        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }

    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            NSLocalizedString("Today", comment: "Today due date description")
        } else {
            formatted(.dateTime.month().day().weekday(.wide))
        }
    }
}
