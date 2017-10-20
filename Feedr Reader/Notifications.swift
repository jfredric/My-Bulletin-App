//
//  Notifications.swift
//  Feedr Reader
//
//  Created by Joshua Fredrickson on 10/19/17.
//  Copyright © 2017 Joshua Fredrickson. All rights reserved.
//

//import Foundation
import UIKit
import UserNotifications
import os.log


class Notifications {
    
    private let center = UNUserNotificationCenter.current()
    private var canAlert = false
    private var canBadge = false
    private var canSound = false
    
    private struct CategoryIdentifier {
        static let general = "GENERAL"
        static let timerExpired = "TIMER_EXPIRED"
        static let newItem = "NEW_ITEM"
    }
    
    static let sharedInstance = Notifications()
    private init() {
        center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            self.canAlert = granted
            self.canSound = granted
            self.canBadge = granted
            
            
            let generalCategory = UNNotificationCategory(identifier: CategoryIdentifier.general,
                                                         actions: [],
                                                         intentIdentifiers: [],
                                                         options: .customDismissAction)
            
            let newItemCategory = UNNotificationCategory(identifier: CategoryIdentifier.newItem,
                                                         actions: [],
                                                         intentIdentifiers: [],
                                                         options: .customDismissAction) // what does this do?
            
            // Create the custom actions for the TIMER_EXPIRED category.
            let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                                    title: "Snooze",
                                                    options: UNNotificationActionOptions(rawValue: 0))
            let stopAction = UNNotificationAction(identifier: "STOP_ACTION",
                                                  title: "Stop",
                                                  options: .foreground)
            
            let expiredCategory = UNNotificationCategory(identifier: CategoryIdentifier.timerExpired,
                                                         actions: [snoozeAction, stopAction],
                                                         intentIdentifiers: [],
                                                         options: UNNotificationCategoryOptions(rawValue: 0))
            // Register the notification categories.
            self.center.setNotificationCategories([generalCategory, newItemCategory, expiredCategory])
        }
    }
    
    func createNotification(identifier: String?, title: String, body: String, time inSeconds: Double) {
        let content = createNotificationContent(title: title, body: body)
        
        let idName = identifier ?? "TimedNotification"
        
        // time interval in seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        // assign (custom) actions to local notification
        content.categoryIdentifier = CategoryIdentifier.timerExpired
        
        // add sound to notification
        content.sound = UNNotificationSound.default() // or UNNotificationSound(named: "customSound.aiff")
        
        // Create the request object.
        let request = UNNotificationRequest(identifier: idName, content: content, trigger: trigger)
        
        // Schedule the request.
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    private func createNotificationContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: body, arguments: nil)
        
        return content
    }
}
