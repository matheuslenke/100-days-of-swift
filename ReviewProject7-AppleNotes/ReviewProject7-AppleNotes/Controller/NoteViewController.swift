//
//  NoteViewController.swift
//  ReviewProject7-AppleNotes
//
//  Created by Matheus Lenke on 01/10/21.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    weak var delegate: ChangeNoteDelegate?
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .systemYellow
        let deleteNoteButton = UIBarButtonItem(barButtonSystemItem: .trash , target: self, action: #selector(deleteNote))
        deleteNoteButton.tintColor = .systemYellow
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        shareButton.tintColor = .systemYellow
        self.navigationItem.rightBarButtonItems = [shareButton, deleteNoteButton]
        
        if let safeNote = note {
            titleTextField.text = safeNote.title
            contentTextView.text = safeNote.content
        }

    }
    
    @objc func deleteNote() {
        if let safeNote = note {
            delegate?.deleteNote(note: safeNote)
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let safeNote = note {
            safeNote.title = titleTextField.text
            safeNote.content = contentTextView.text
            delegate?.noteChanged(note: safeNote)
        }
    }
    
    @objc func shareTapped() {
        let sharingText = """
        Check out my note:
        \(note?.title ?? "")
        \(note?.content ?? "")
        """
        let vc = UIActivityViewController(activityItems: [sharingText], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
