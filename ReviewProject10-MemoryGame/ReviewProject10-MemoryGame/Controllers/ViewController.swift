//
//  ViewController.swift
//  ReviewProject10-MemoryGame
//
//  Created by Matheus Lenke on 27/10/21.
//

import UIKit

class ViewController: UICollectionViewController {

    var words = [WordItem]()
    
    var wordsCollection = [Word]()
    
    var firstSelected: String?
    var secondSelected: String?
    
    var score = 0
    var restartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item1 = WordItem(inLanguage1: Word(name: "Oi", language: K.languages.portuguese), inLanguage2: Word(name:"Hello", language: K.languages.english))
        let item2 = WordItem(inLanguage1: Word(name: "Tchau", language: K.languages.portuguese), inLanguage2: Word(name:"Bye", language: K.languages.english))
        let item3 = WordItem(inLanguage1: Word(name: "Vermelho", language: K.languages.portuguese), inLanguage2: Word(name:"Rouge", language: K.languages.french))
        let item4 = WordItem(inLanguage1: Word(name: "Yellow", language: K.languages.english), inLanguage2: Word(name:"Amarillo", language: K.languages.spanish))
        let item5 = WordItem(inLanguage1: Word(name: "Computador", language: K.languages.portuguese), inLanguage2: Word(name:"Computer", language: K.languages.english))
        let item6 = WordItem(inLanguage1: Word(name: "Celular", language: K.languages.portuguese), inLanguage2: Word(name:"Smartphone", language: K.languages.english))
        let item7 = WordItem(inLanguage1: Word(name: "Apple", language: K.languages.english), inLanguage2: Word(name:"Maçã", language: K.languages.portuguese))

//
        words.append(contentsOf: [item1, item2, item3, item4, item5, item6, item7])
        startGame()
        
        restartButton = UIButton()
        restartButton.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        restartButton.setTitle("Play again", for: .normal)
        restartButton.setTitleColor(.systemBlue, for: .normal)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(restartButton)
        restartButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        restartButton.bottomAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        restartButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        restartButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        restartButton.isHidden = true
        
        collectionView.register(UINib(nibName: "CardCell" , bundle: nil), forCellWithReuseIdentifier: "Card")
    }
    
    @objc func startGame() {
        title = "Memory Game"
        
        for word in words {
            wordsCollection.append(word.inLanguage1)
            wordsCollection.append(word.inLanguage2)
        }
        
        wordsCollection.shuffle()
        firstSelected = nil
        secondSelected = nil
        collectionView.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordsCollection.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath) as? CardCell else { fatalError("Couldn't dequeue a cell")}
        
        let word = wordsCollection[indexPath.item]
        let wordForRow = word.name
        cell.selectedWord = wordForRow
        cell.selectedLanguage = word.language
        cell.renderFrontFace()
        cell.renderBackFace()
        cell.showCorrectFace(isSelected: word.isSelected )
        
        if let wordItem = words.first(where: { word in
            return word.inLanguage1.name == wordForRow || word.inLanguage2.name == wordForRow
        }) {
            cell.originalWord = wordItem
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else { return }
        guard let selectedWord = cell.selectedWord else { return }
        guard let originalWord = cell.originalWord else { return }
        

        if firstSelected == nil {
            firstSelected = selectedWord
            
            wordsCollection[indexPath.item].isSelected = true
            cell.flipCard(isSelected: wordsCollection[indexPath.item].isSelected)
            title = "First selected"
            
        } else if firstSelected == selectedWord {
            
        } else if secondSelected == nil {
            secondSelected = selectedWord
            
            wordsCollection[indexPath.item].isSelected = true
            cell.flipCard(isSelected: wordsCollection[indexPath.item].isSelected)
            title = "Evaluating...."
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
               // Code you want to be delayed
                self.evaluateCards(word: originalWord )
            }
            
        }
        
    }
    
    func evaluateCards(word: WordItem) {
        guard let firstString = firstSelected else { return }
        guard let secondString = secondSelected else { return }
        guard let firstWordIndex = wordsCollection.firstIndex(where: {item in item.name == firstString}) else { return }
        guard let secondWordIndex = wordsCollection.firstIndex(where: {item in item.name == secondString}) else { return }
        
        
        let firstCell = collectionView.visibleCells.first { cell in
            guard let cardCell = cell as? CardCell else { return false }
            guard let cardWord = cardCell.selectedWord else { return false }
            
            return cardWord == firstString
        } as! CardCell
        let secondCell = collectionView.visibleCells.first { cell in
            guard let cardCell = cell as? CardCell else { return false }
            guard let cardWord = cardCell.selectedWord else { return false }
            
            return cardWord == secondString
        } as! CardCell
        
        guard let originalWord = firstCell.originalWord else { return }
        
        if originalWord.inLanguage1.name == firstString && originalWord.inLanguage2.name == secondString {
            userGotRight(firstCell: firstCell, secondCell: secondCell)
        } else if originalWord.inLanguage1.name == secondString && originalWord.inLanguage2.name == firstString {
            userGotRight(firstCell: firstCell, secondCell: secondCell)
        } else {
            userGotWrong(firstCell: firstCell, secondCell: secondCell)
            wordsCollection[firstWordIndex].isSelected = false
            wordsCollection[secondWordIndex].isSelected = false
        }
    }
    
    func userGotRight(firstCell: CardCell, secondCell: CardCell) {
        title = "Correct!"
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
           // Code you want to be delayed
            firstCell.removeFromSuperview()
            secondCell.removeFromSuperview()
            
            guard let index1 = self.wordsCollection.firstIndex(where: {item in item.name == self.firstSelected}) else { return }
            self.wordsCollection.remove(at: index1)
            guard let index2 = self.wordsCollection.firstIndex(where: {item in item.name == self.secondSelected}) else { return }
            self.wordsCollection.remove(at: index2)
            
            self.firstSelected = nil
            self.secondSelected = nil
            self.title = "Memory Game"
            self.collectionView.reloadData()
            
            if self.wordsCollection.count == 0 {
                self.title = "You Win!"
                self.restartButton.isHidden = false
            }
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        startGame()
        self.restartButton.isHidden = true
    }
    
    func userGotWrong(firstCell: CardCell, secondCell: CardCell) {
        title = "Wrong!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
           // Code you want to be delayed
            firstCell.flipCard(isSelected: false)
            secondCell.flipCard(isSelected: false)
            self.firstSelected = nil
            self.secondSelected = nil
            self.title = "Memory Game"
        }
    }
    
}



