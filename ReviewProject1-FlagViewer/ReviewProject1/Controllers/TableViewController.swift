//
//  ViewController.swift
//  ReviewProject1
//
//  Created by Matheus Lenke on 27/06/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 90.0
        
        
        title = "Flags Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Loading flag images
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix(".png") {
                // This is a picture to load!
                countries.append(item)
            }
        }
        print(countries)
        countries.sort { item1, item2 in
            item1 < item2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        
        cell.textLabel?.text = countries[indexPath.row]
        cell.imageView?.image = imageWithImage(UIImage(named: countries[indexPath.row])!, scaledToSize: CGSize(width: 100, height: 70))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = countries[indexPath.row]
            vc.selectedTitle = "\(countries[indexPath.row])"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func imageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0 ,y: 0 ,width: newSize.width ,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }

}

