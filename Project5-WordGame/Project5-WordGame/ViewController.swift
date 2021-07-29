//
//  ViewController.swift
//  Project5-WordGame
//
//  Created by Matheus Lenke on 12/07/21.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        let defaults = UserDefaults.standard
        if let savedWord = defaults.string(forKey: "title") {
            title = savedWord
            if let savedUsedWords = defaults.stringArray(forKey: "usedWords") {
                usedWords = savedUsedWords
            }
        } else {
            startGame()
        }
        
        
    }

    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        let defaults = UserDefaults.standard
        defaults.set(title, forKey: "title")
        defaults.set(usedWords, forKey: "usedWords")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if !isSameWord(word: lowerAnswer) {
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        if !isTooSmall(word: lowerAnswer) {
                            usedWords.insert(lowerAnswer, at: 0)
                            let defaults = UserDefaults.standard
                            defaults.set(usedWords, forKey: "usedWords")
                            
                            let indexPath = IndexPath(row: 0, section: 0)
                            tableView.insertRows(at: [indexPath], with: .automatic)
                            return
                        } else {
                            showErrorMessage(title: "Word too small", message: "Minimun length of 3 characters")
                        }
                    } else {
                        showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
                    }
                } else {
                    showErrorMessage(title: "Word already used", message: "Be more original!")
                }
            } else {
                showErrorMessage(title: "Word not possible", message: "You can't spell that word form \(title!.lowercased())")
            }
        } else {
            showErrorMessage(title: "This is the title word!", message: "You can't use \"\(title!.lowercased())\" again!")
        }

    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isSameWord(word: String) -> Bool {
        guard let tempWord = title?.lowercased() else { return false }
        return word == tempWord
    }
    
    func isTooSmall(word: String) -> Bool {
        if word.count < 3 {
            return true
        }
        return false
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
}

