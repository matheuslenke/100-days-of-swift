//
//  ViewController.swift
//  ReviewProject4-PhotoGallery
//
//  Created by Matheus Lenke on 29/07/21.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()
    var pictureToCreate: Picture?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPicture))
        navigationItem.rightBarButtonItem = addButton
        
        let defaults = UserDefaults.standard
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
                tableView.reloadData()
            } catch {
                print("Failed to load Pictures.")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let picture = pictures[indexPath.row]
            print(picture)
            let path = getDocumentsDirectory().appendingPathComponent(picture.filename)
            vc.selectedImage = path.path
            vc.selectedCaption = picture.caption
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = pictures[indexPath.row].caption
        return cell
    }
    
    @objc func addPicture() {
        let ac = UIAlertController(title: "Required info", message: "Enter a caption for this Picture", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak ac] _ in
            guard let caption = ac?.textFields?[0].text else { return }
            self?.pictureToCreate = Picture(filename: "", caption: caption)
            
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
            self?.present(picker, animated: true)
        })
        present(ac, animated: true)

    }
    
    func askForCaptionName(imageName: String) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        self.pictureToCreate?.filename = imageName
        self.pictures.append(self.pictureToCreate!)
        self.save()
        pictureToCreate = nil
        tableView.reloadData()
        dismiss(animated: true)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures.")
        }
    }

}


