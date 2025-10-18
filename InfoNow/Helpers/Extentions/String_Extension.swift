//
//  String_Extension.swift
//  InfoNow
//
//  Created by Stefan kund on 16/10/2025.
//

import Foundation

extension String {
    var timeFormater: String {
        
        let isoDateFormater = ISO8601DateFormatter()
        isoDateFormater.timeZone = TimeZone(identifier: "FR")
        if let date = isoDateFormater.date(from: self) {
            if date.isToday {
                
                let duration = abs(date.timeIntervalSinceNow)
                
                let hours = duration / 3600
                let minutes = duration / 60
                
                var preFix: String!
                var stringDuration: String!
                if hours > 1 {
                    preFix = NSLocalizedString("TX_0004", comment: "heurs")
                    stringDuration = String(format: "%.0f", hours)
                } else {
                    preFix = NSLocalizedString("TX_0003", comment: "minutes")
                    stringDuration = String(format: "%.0f", minutes)
                }
                
                return String.localizedStringWithFormat(NSLocalizedString("TX_0002", comment: "Il y a .. minutes/heurs"), stringDuration, preFix)
            } else {
                let displayFormatter = DateFormatter()
                displayFormatter.dateStyle = .medium
                displayFormatter.timeStyle = .short
                displayFormatter.locale = .current
                
                let formatted = displayFormatter.string(from: date)
                return formatted
            }
        } else {
            return ""
        }
    }
}
