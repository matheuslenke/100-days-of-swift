//
//  ViewController.swift
//  HWS-Project1
//
//  Created by Matheus Lenke on 20/06/21.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global().async {
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
//            Loading Pictures from disk
            var loadedPictures = [Picture]()
            if let savedPictures = defaults.object(forKey: "pictures") as? Data {
                let jsonDecoder = JSONDecoder()
                
                do {
                    loadedPictures = try jsonDecoder.decode([Picture].self, from: savedPictures)
                    print(loadedPictures)
                } catch {
                    print("Failed to load pictures")
                }
            }
            
            for item in items {
                if item.hasPrefix("nssl") {
                    // This is a picture to load!
                    if let foundPicture = loadedPictures.first(where: { pic in
                        return pic.name == item
                    }) {
                        self.pictures.append(foundPicture)
                    } else {
                        let picture = Picture(name: item, timesViewed: 0)
                        self.pictures.append(picture)
                        self.save()
                        
                    }
                }
            }
            self.pictures.sort { item1, item2 in
                item1.name < item2.name
            }
        }
        
        DispatchQueue.main.async {
            [weak self] in
            self?.collectionView.reloadData()
        }
        

        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? ImageCell else {
            fatalError("Unable to dequeue a ImageCell")
        }
        
        cell.name.text = pictures[indexPath.item].name
        cell.imageView.image = UIImage(named: pictures[indexPath.item].name)
        cell.imageView.sizeToFit()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let picture = pictures[indexPath.item]
            vc.selectedImage = picture.name
            vc.selectedTitle = "Picture \(indexPath.item + 1) of \(pictures.count)"
            pictures[indexPath.item].timesViewed += 1
            save()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        }  else {
            print("Failed to save pictures")
        }
    }
    
}

