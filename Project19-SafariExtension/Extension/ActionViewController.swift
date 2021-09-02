//
//  ActionViewController.swift
//  Extension
//
//  Created by Matheus Lenke on 26/08/21.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var Script: UITextView!
    @IBOutlet weak var scriptName: UITextField!
    
    var currentScripts = [ScriptData]()
    
    var pageTitle = ""
    var pageURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let selectButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(selectScript))
        
        navigationItem.rightBarButtonItems = [selectButtonItem, doneButtonItem]
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) {
                    [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    let urlString = javaScriptValues["URL"] as? String ?? ""
                        
                    DispatchQueue.main.async {
                        self?.pageURL = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                        self?.title = self?.pageTitle
                        self?.loadDefaultScripts()
                    }
                
                }
                
            }
        }

    
    }
    
    func loadDefaultScripts() {
        
        let defaults = UserDefaults.standard
        
        DispatchQueue.global().async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            _ = try! fm.contentsOfDirectory(atPath: path)

            guard let siteHost = self.pageURL?.host else { return }
            
//            Loading Scripts from disk
            var loadedScripts = [ScriptData]()
            if let savedScripts = defaults.object(forKey: siteHost) as? Data {
                let jsonDecoder = JSONDecoder()
                
                do {
                    loadedScripts = try jsonDecoder.decode([ScriptData].self, from: savedScripts)
                    print(loadedScripts)
                    self.currentScripts = loadedScripts
                } catch {
                    print("Failed to load pictures")
                }
            }
        }
    }

    @IBAction func done() {
        if (scriptName.text != "" && Script.text != "" ) {
            let newScript = ScriptData(name: scriptName.text ?? "No name", content: Script.text)
            currentScripts.append(newScript)
            save()            
        }
        runScript()
       
    }
    
    func runScript() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": Script.text ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [ customJavaScript ]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func selectScript() {
        let ac = UIAlertController(title: "Select script", message: "Select a script from the list", preferredStyle: .alert)
        for scriptItem in currentScripts {
            ac.addAction(UIAlertAction(title: scriptItem.name, style: .default, handler: { _ in
                self.Script.text = scriptItem.content
                self.runScript()
            }))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            Script.contentInset = .zero
        } else {
            Script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
            
            Script.scrollIndicatorInsets = Script.contentInset
            
            let selectedRange = Script.selectedRange
            Script.scrollRangeToVisible(selectedRange)
        }
    }
    
//    Saving userDefaults to disk
    func save() {
        guard let host = self.pageURL?.host else { return }
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(currentScripts) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: host)
        }  else {
            print("Failed to save scripts")
        }
    }

}
