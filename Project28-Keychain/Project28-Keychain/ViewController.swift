//
//  ViewController.swift
//  Project28-Keychain
//
//  Created by Matheus Lenke on 24/10/21.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    var userHasPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getUserHasPassword()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error ) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // Error authenticating user
                        let ac = UIAlertController(title: "Authentication Failed", message: "You could not be verified, please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // No biometry
            if userHasPassword {
                askForPassword()
            } else {
                let ac = UIAlertController(title: "Biometry Unavailable", message: "Your device is not configured for biometric authentication. Please set a password", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                    self?.createPassword()
                })
                present(ac, animated: true)
            }
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSecretMessage))
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        navigationItem.rightBarButtonItem = nil
        title = "Nothing to see here"
    }
    
    @objc func createPassword() {
        let ac = UIAlertController(title: "New password", message: "Enter your password below and its confirmation", preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        ac.addTextField { textField in
            textField.placeholder = "Confirm Password"
            textField.isSecureTextEntry = true
        }
        ac.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] action in
            guard let password = ac.textFields?[0].text else { return }
            guard let confirmationPassword = ac.textFields?[1].text else { return }
            
            if password == confirmationPassword {
                self?.savePassword(password: password)
                self?.showAlert(title: "Success", message: "Password set!")
            } else {
                self?.showAlert(title: "Validation Error", message: "Password and confirmation does not match!")
            }
        }))
        present(ac, animated: true)
    }
    
    func askForPassword() {
        let ac = UIAlertController(title: "Enter Password", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "*****"
            textField.isSecureTextEntry = true
        }
        ac.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] action in
            guard let password = ac.textFields?[0].text else { return }
            if let userHasPassword = self?.validatePassword(password: password) {
                if userHasPassword {
                    self?.unlockSecretMessage()
                } else {
                    self?.showAlert(title: "Wrong password", message: "Please try again")
                }
            }
        }))
        ac.addAction(UIAlertAction(title: "Reset password", style: .destructive, handler: { [weak self] action in
            self?.resetPassword()
            self?.showAlert(title: "Success", message: "Your password was reset successfully")
        }))
        present(ac, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: false)
    }
    
    func savePassword(password: String) {
        KeychainWrapper.standard.set(password, forKey: "Password")
        userHasPassword = true
    }
    
    func getUserHasPassword() {
        if KeychainWrapper.standard.data(forKey: "Password") != nil {
            userHasPassword = true
        }
    }
    
    func validatePassword(password: String) -> Bool {
        if let actualPassword = KeychainWrapper.standard.data(forKey: "Password") {
            let string = String(decoding: actualPassword, as: UTF8.self)
            
            if string == password {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func resetPassword() {
        KeychainWrapper.standard.removeObject(forKey: "Password")
        userHasPassword = false
    }
    
}

