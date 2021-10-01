//
//  ViewController.swift
//  ReviewProject7-AppleNotes
//
//  Created by Matheus Lenke on 30/09/21.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var notes = [Note]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My notes"
        navigationController?.navigationBar.prefersLargeTitles = true

        loadItems()
        
        let squareAndPencilImage = UIImage(systemName: "square.and.pencil")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        let addNewNoteButton = UIBarButtonItem(image: squareAndPencilImage , style: .plain, target: self, action: #selector(createNewNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [spacer, addNewNoteButton]
        navigationController?.isToolbarHidden = false
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NoteTableViewCell

        cell.titleLabel.text = notes[indexPath.row].title
        cell.subtitleLabel.text = notes[indexPath.row].content
        return cell
    }
    
    
    @objc func createNewNote() {
        let newNote = Note(context: self.context)
        newNote.title = "Change your title"
        newNote.content = "Write here"
        newNote.id = UUID()
        newNote.createdAt = Date.now
        notes.append(newNote)
        
        tableView.reloadData()
        
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
            newViewController.note = newNote
            newViewController.delegate = self
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    
    
    //MARK - Navigate to note details method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToNoteDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "GoToNoteDetails" {
               let destinationVC = segue.destination as! NoteViewController
               destinationVC.delegate = self
               if let indexPath = tableView.indexPathForSelectedRow {
                   destinationVC.note = notes[indexPath.row]
               }
           }
   }

    //MARK - Model Manipulation Methods
    
    func saveItems() {
        do {
            try self.context.save()
        } catch {
            print("Failed to save")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveItems()
    }
}

extension ViewController: ChangeNoteDelegate {
    func noteChanged(note: Note) {
        if let i = notes.firstIndex(where: {$0.id?.uuidString == note.id?.uuidString}) {
            notes[i] = note
            saveItems()
        }
    }
    
    func deleteNote(note: Note) {
        if let i = self.notes.firstIndex(where: {$0.id?.uuidString == note.id?.uuidString}) {
            context.delete(notes[i])
            notes.remove(at: i)
            tableView.reloadData()
        }
    }
}
