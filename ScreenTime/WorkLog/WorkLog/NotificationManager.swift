//
//  NotificationManager.swift
//  Worklog
//
//  Created by 김영빈 on 2023/05/09.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    //MARK: 알림 권한요청
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) {(success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    //MARK: 노티피케이션 생성 및 요청
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "This is my first notification!"
        content.subtitle = "I am Tester!"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false) // 10초 후에 알림
        
        // 알림 요청 생성
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        // 알림 요청 추가
        UNUserNotificationCenter.current().add(request)
    }
}