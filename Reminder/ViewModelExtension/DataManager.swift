//
//  DateTimeManager.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 7/1/2564 BE.
//

import Foundation


protocol DataManager {
    func getDate(from date: Date, isEnabled: Bool) -> Date?
    func getTime(from time: Date, isEnabled: Bool) -> Date?
    func getText(text: String) -> String?
}

extension DataManager {
    func getDate(from date: Date, isEnabled: Bool) -> Date?{
        if isEnabled {
            let calendar = Calendar.current
            var component = DateComponents()
            component.day = calendar.component(.day, from: date)
            component.month = calendar.component(.month, from: date)
            component.year = calendar.component(.year, from: date)
            return calendar.date(from: component)
        }
        return nil
    }
    
    func getTime(from time: Date, isEnabled: Bool) -> Date? {
        if isEnabled {
            let calendar = Calendar.current
            var component = DateComponents()
            component.hour = calendar.component(.hour, from: time)
            component.minute = calendar.component(.minute, from: time)
            return calendar.date(from: component)
        }
        return nil
    }
    
    func getText(text: String) -> String? {
        if text == "" {
            return nil
        }
        return text
    }
    
}
