//
//  NotificationService.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 03.04.2024.
//

import UserNotifications

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    
    func addNotification(){ // TODO: обдумать поведение при первом запуске
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("notificationTitle", comment: "")
        content.body = NSLocalizedString("notificationBody", comment: "")
        content.sound = UNNotificationSound.default
        let seconds = UserDefaults.standard.double(forKey: "NotificationTime")
        let date = Date(timeIntervalSince1970: seconds)
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
