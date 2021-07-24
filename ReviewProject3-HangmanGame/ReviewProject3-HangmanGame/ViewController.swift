//
//  ViewController.swift
//  ReviewProject3-HangmanGame
//
//  Created by Matheus Lenke on 23/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var wordLabel: UILabel!
    var allWords = [String]()
    var usedLetters = [String]() {
        didSet {
            setPromptWord()
        }
    }
    var selectedWord = ""
    var promptWord = ""
    var wrongAnswersCount = 10
    var score = 0 {
        didSet {
            titleLabel.text = "Score: \(score)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async { [weak self] in
            if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
                if let startWords = try? String(contentsOf: startWordsURL) {
                    self?.allWords = startWords.components(separatedBy: "\n")
                }
                self?.allWords = (self?.allWords.filter({ word in
                    if (word != "") {
                        return true
                    } else { return false }
                }))!
                DispatchQueue.main.async { [weak self] in
                    self?.startGame()
                }
            }
        }

    }
    
    
    func startGame() {
        score = 0
        wrongAnswersCount = 10
        selectedWord = allWords.randomElement()?.uppercased() ?? "PARTY"
        setPromptWord()
        titleLabel.text = "Score: \(score)"
        usedLetters = [String]()
    }
    
    func setPromptWord() {
        if selectedWord == "" {
            return
        }
        promptWord = ""
        for letter in selectedWord {
            let strLetter = String(letter)

            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        print(promptWord)
        wordLabel.text = promptWord
    }

    @IBAction func guessButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Enter letter", message: nil, preferredStyle: .alert)
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
        let upperAnswer = answer.uppercased()
        
        if upperAnswer.count > 1 {
            showErrorMessage(title: "Error", message: "You can only type letters")
            return
        }
        
        if usedLetters.contains(upperAnswer) {
            showErrorMessage(title: "Error", message: "Character already used")
        }
        
        if selectedWord.contains(upperAnswer) {
            score += 1
        } else {
            wrongAnswersCount -= 1
            showErrorMessage(title: "Wrong!", message: "This word doesn't contain this letter!")
        }
        
        if(wrongAnswersCount == 0) {
            loseGame()
        }
        usedLetters.append(upperAnswer)
        
        var hasWon = true
        for letter in selectedWord {
            let strLetter = String(letter)
            if !usedLetters.contains(strLetter) {
                hasWon = false
            }
        }
        if hasWon {
            winGame()
        }
        
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    func winGame() {
        let ac = UIAlertController(title: "Condragulations!", message: "You won!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play again", style: .default))
        present(ac, animated: true)
        startGame()
    }
    
    func loseGame() {
        let ac = UIAlertController(title: "I'm Sorry", message: "You lost!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Play again", style: .default))
        present(ac, animated: true)
        startGame()
    }

    
}

