//
//  Extension.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//
// swiftlint:disable identifier_name

import Foundation
import SwiftUI

extension Date {
    var millisecondSince1978: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, self.count)])
        }
    }
}

extension Double {
    func formated2Decimal() -> String {
        return String(format: "%.2f", self)
    }
}

extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}

extension String {
    func timeAgoSinceDate() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = formatter.date(from: self) {
            let calendar = Calendar.current
            let flags: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
            let now = Date()
            let components = calendar.dateComponents(flags, from: date, to: now)

            if let year = components.year, year >= 1 {
                return year == 1 ? "a year ago" : "\(year) years ago"
            } else if let month = components.month, month >= 1 {
                return month == 1 ? "a month ago" : "\(month) months ago"
            } else if let week = components.weekOfYear, week >= 1 {
                return week == 1 ? "a week ago" : "\(week) weeks ago"
            } else if let day = components.day, day >= 1 {
                return day == 1 ? "a day ago" : "\(day) days ago"
            } else if let hour = components.hour, hour >= 1 {
                return hour == 1 ? "an hour ago" : "\(hour) hours ago"
            } else if let minute = components.minute, minute >= 1 {
                return minute == 1 ? "a minute ago" : "\(minute) minutes ago"
            } else if let second = components.second, second >= 1 {
                return second == 1 ? "a seconde ago" : "\(second) secondes ago"
            } else {
                return "maintenant"
            }
        }
        return ""
    }
}

extension StringOuCorrector {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let corrector = try? container.decode(Corrector.self) {
            self = .corrector(corrector)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Données non conformes")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .corrector(let corrector):
            try container.encode(corrector)
        case .string(let string):
            try container.encode(string)
        }
    }
}
