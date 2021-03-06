//
//  ViewController.swift
//  Project2
//
//  Created by Matheus Lenke on 21/06/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var highscoreLabel: UILabel!
    
    var countries = [String]()
    var score = 0
    var highscore = 0 {
        didSet {
            highscoreLabel.text = "Highscore: \(highscore)"
        }
    }
    var correctAnswer = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Asking for notification permission
        registerLocal()
        // Scheduling a daily notification
        scheduleLocal()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let defaults = UserDefaults.standard
        
        let savedHighscore = defaults.integer(forKey: "Highscore")
        highscore = savedHighscore
        
        scoreLabel.text = "Score: \(score)"
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        if questionsAsked == 10 {
            finishGame()
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
        
        questionsAsked += 1
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
           animations: {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        })
        
        if sender.tag == correctAnswer {
            let defaults = UserDefaults.standard
            title = "Correct!"
            score += 1
            if score > highscore {
                highscore = score
                defaults.set(highscore, forKey: "Highscore")
            }
        } else {
            title = "Wrong! this is the flag of \(countries[sender.tag].uppercased()) "
            score -= 1
        }
        scoreLabel.text = "Score: \(score)"
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: {
            _ in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [],
               animations: {
                sender.transform = .identity
            })
            self.askQuestion()
        }))
        
        present(ac, animated: true)
    }
    
    func finishGame() {
        let correctPercentage = Int(Double(score) / Double(questionsAsked) * 100)
        let ac = UIAlertController(title: "Game Finished!", message: "Your final score is \(score)! you got \(correctPercentage)% correct", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
    
}

extension ViewController : UNUserNotificationCenterDelegate {
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Yuhuul")
                self.scheduleLocal()
            } else {
                print("D'oh!")
            }
        }
        
    }
    
    
    
    @objc func scheduleLocal() {
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Let's play some games?"
        content.body = "Let's play Flag Guesser! Sure you'll have a lot of fun"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = .default
        
//        Schedule to appear everyday
        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 33
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        print("It worked")
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let play = UNNotificationAction(identifier: "play", title: "Lets play!", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [play], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
}
