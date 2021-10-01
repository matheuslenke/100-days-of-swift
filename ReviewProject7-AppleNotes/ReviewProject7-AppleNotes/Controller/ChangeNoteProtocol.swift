//
//  ChangeNoteProtocol.swift
//  ReviewProject7-AppleNotes
//
//  Created by Matheus Lenke on 01/10/21.
//

import Foundation

protocol ChangeNoteDelegate: class {
    func noteChanged(note: Note)
    func deleteNote(note: Note)
}
