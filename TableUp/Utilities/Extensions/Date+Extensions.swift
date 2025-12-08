//
//  Date+Extensions.swift
//  TableUp
//
//  Date utility extensions
//

import Foundation

extension Date {
    // MARK: - Formatting
    func formatted(style: DateStyle) -> String {
        switch style {
        case .time:
            return formatted(date: .omitted, time: .shortened)
        case .date:
            return formatted(date: .abbreviated, time: .omitted)
        case .dateTime:
            return formatted(date: .abbreviated, time: .shortened)
        case .relative:
            return relativeFormatted()
        case .full:
            return formatted(date: .long, time: .shortened)
        }
    }

    enum DateStyle {
        case time
        case date
        case dateTime
        case relative
        case full
    }

    // MARK: - Relative Formatting
    private func relativeFormatted() -> String {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(self) {
            let components = calendar.dateComponents([.hour, .minute], from: now, to: self)
            if let hours = components.hour, hours > 0 {
                return "in \(hours)h"
            } else if let minutes = components.minute, minutes > 0 {
                return "in \(minutes)m"
            } else {
                return "now"
            }
        } else if calendar.isDateInTomorrow(self) {
            return "Tomorrow"
        } else if let days = calendar.dateComponents([.day], from: now, to: self).day, days > 0, days < 7 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Day of week
            return formatter.string(from: self)
        } else {
            return formatted(date: .abbreviated, time: .omitted)
        }
    }

    // MARK: - Time Sections
    func timeSection() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) {
            let hour = calendar.component(.hour, from: self)
            if hour < 12 {
                return "This Morning"
            } else if hour < 17 {
                return "This Afternoon"
            } else {
                return "Tonight"
            }
        } else if calendar.isDateInTomorrow(self) {
            return "Tomorrow"
        } else if let days = calendar.dateComponents([.day], from: Date(), to: self).day, days >= 0, days < 7 {
            return "This Week"
        } else {
            return "Later"
        }
    }

    // MARK: - Add Time
    func adding(hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: self) ?? self
    }

    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
}
