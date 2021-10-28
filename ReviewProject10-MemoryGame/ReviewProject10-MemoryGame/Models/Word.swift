//
//  Word.swift
//  ReviewProject10-MemoryGame
//
//  Created by Matheus Lenke on 27/10/21.
//

import Foundation

struct Word: Codable {
    let name: String
    let language: String
    var isSelected = false
}

struct WordItem {
    var inLanguage1: Word
    var inLanguage2: Word
}
