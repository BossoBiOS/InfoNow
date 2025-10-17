//
//  Date_Extention.swift
//  InfoNow
//
//  Created by Stefan kund on 16/10/2025.
//

import Foundation

extension Date {
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self) == calendar.startOfDay(for: Date())
    }
}
