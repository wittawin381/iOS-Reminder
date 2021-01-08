//
//  NotifiactionManager.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 7/1/2564 BE.
//

import Foundation
import UIKit
import UserNotifications

class NotificationManager : NSObject{
    static var noti = NotificationManager()
    let center = UNUserNotificationCenter.current()
    private override init() {
        super.init()
        authen()
        
    }
    
    
    func authen() {
        center.requestAuthorization(options: [.alert,.badge,.announcement,.sound], completionHandler: {granted, error in
            
        })
    }
    
    func request(from reminder: Reminders) {
        request(identifier: reminder.id!.uuidString, title: reminder.title!, subtitle: reminder.note ?? "", body: "", date: reminder.date, time: reminder.time)
    }
    
    func request(identifier: String,title: String,subtitle: String = "", body: String = "", date: Date? = nil, time: Date? = nil) {
//        center.delegate = self
        if date != nil {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            let alarm = self.alarm(date: date, time: time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: alarm, repeats: false)
            
            let completeAction = UNNotificationAction(
                identifier: "COMPLETE",
                title: "Complete",
                options: UNNotificationActionOptions.init(rawValue: 0)
            )
            
            let completionCategory = UNNotificationCategory(
                identifier: "COMPLETION_ACTION",
                actions: [completeAction],
                intentIdentifiers: [],
                hiddenPreviewsBodyPlaceholder: "",
                options: [.customDismissAction]
            )
            content.userInfo = ["ID":identifier]
            content.categoryIdentifier = "COMPLETION_ACTION"
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.setNotificationCategories([completionCategory])
            center.add(request, withCompletionHandler: {_ in})
        }
    }
    
    func update(from reminder: Reminders) {
        update(identifier: reminder.id!.uuidString, title: reminder.title!, subtitle: reminder.note ?? "", body: "", date: reminder.date, time: reminder.time)
    }
    
    func update(identifier: String,title: String,subtitle: String = "", body: String = "", date: Date? = nil, time: Date? = nil) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        request(identifier: identifier, title: title, subtitle: subtitle, body: body, date: date, time: time)
    }
    
    func remove(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func alarm(date: Date?,time: Date?) -> DateComponents {
        var dateComponent = DateComponents()
        let calendar = Calendar.current
        if date != nil {
            dateComponent.year = calendar.component(.year, from: date!)
            dateComponent.month = calendar.component(.month, from: date!)
            dateComponent.day = calendar.component(.day, from: date!)
        }
        if time != nil {
            dateComponent.hour = calendar.component(.hour, from: time!)
            dateComponent.minute = calendar.component(.minute, from: time!)
        }
        
        return dateComponent
    }
    
}
