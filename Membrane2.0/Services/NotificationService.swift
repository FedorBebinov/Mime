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
        let content = UNMutableNotificationContent()
        content.title = "Время пообщаться"
        content.subtitle = "Хочу пообщаться с имя"
        content.sound = UNNotificationSound.default
        var dateComponent = DateComponents()
        dateComponent.hour = Int(UserDefaults.standard.double(forKey: "NotificationTime")) / 3600
        dateComponent.minute = (Int(UserDefaults.standard.double(forKey: "NotificationTime")) / 60) % 60
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
