//
//  NotificationService.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 03.04.2024.
//

import UserNotifications

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()
    func addNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Время пообщаться"
        content.subtitle = "Хочу пообщаться с имя"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
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
