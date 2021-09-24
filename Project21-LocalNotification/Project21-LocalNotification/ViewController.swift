//
//  ViewController.swift
//  Project21-LocalNotification
//
//  Created by Matheus Lenke on 22/09/21.
//

import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register",  style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule",  style: .plain, target: self, action: #selector(firstSchedule))
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yuhuul")
            } else {
                print("D'oh!")
            }
        }
        
    }
    
    @objc func firstSchedule() {
        scheduleLocal(delay: 5)
    }
    

    @objc func scheduleLocal(delay: TimeInterval) {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worn, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
//        Schedule to appear everyday
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let show24 = UNNotificationAction(identifier: "show24", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, show24], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }

    internal func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                let ac = UIAlertController(title: "Yay", message: "You swiped to unlock! nice", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Sure!", style: .default))
                present(ac, animated: true)
                
            case "show":
                let ac = UIAlertController(title: "Yay", message: "You selected to show!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Sure!", style: .default))
                present(ac, animated: true)
                
            case "show24":
                let ac = UIAlertController(title: "Yay", message: "You selected the 24h alarm!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Sure!", style: .default))
                present(ac, animated: true)
                scheduleLocal(delay: 86400 )
            default:
                break;
                
            }
        }
        completionHandler()
    
    }

}

