//
//  ViewController.swift
//  Project10-PeopleNames
//
//  Created by Matheus Lenke on 24/07/21.
//
import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()
    
    var isUserAuthenticated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(authenticateUser))
        
        authenticateUser()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable do dequeue a PersonCell") // It will crash imediately if it fails
        }
        let person = people[indexPath.item]
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        cell.name.text = people[indexPath.row].name
        return cell
    }
    
    @objc func addNewPerson() {
        
        let ac = UIAlertController(title: "Add Contact", message: "Where do you want to load your photo from?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "From library", style: .default, handler: { _ in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        }))
        ac.addAction(UIAlertAction(title: "From Camera", style: .default, handler: { _ in
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true)
        }))
        present(ac, animated: true)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Edit Contact", message: "What do you want to do?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Rename Contact", style: .default, handler: { _ in
            self.renamePerson(person)
        }))
        ac.addAction(UIAlertAction(title: "Delete contact", style: .destructive, handler: { _ in
            self.deletePerson(at: indexPath.item)
        }))
        ac.addAction(UIAlertAction(title: "Return", style: .default))
        present(ac, animated: true)
    }
    
    func renamePerson(_ person: Person) {
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func deletePerson(at index: Int) {
        people.remove(at: index)
        collectionView.reloadData()
    }
    
    func loadContacts() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self?.addNewPerson))
        }
        if let data = KeychainWrapper.standard.data(forKey: "Contacts") {
            do {
                let decoder = JSONDecoder()
                if let loadedPeople = try? decoder.decode([Person].self, from: data) {
                    self.people = loadedPeople
                }
                let notificationCenter = NotificationCenter.default
                notificationCenter.addObserver(self, selector: #selector(saveContacts), name: UIApplication.willResignActiveNotification, object: nil)
                collectionView.reloadData()
            }
        }
    }
    
    @objc func saveContacts() {
        do {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(people) {
                KeychainWrapper.standard.set(data, forKey: "Contacts")
            }
        }
    }
    
    // MARK: Authentication methods
    
    @objc func authenticateUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error ) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.isUserAuthenticated = true
                        self?.loadContacts()
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
            let ac = UIAlertController(title: "Biometry Unavailable", message: "Your device is not configured for biometric authentication", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
}

