//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	var items = [String]() // this is the array that will store the filenames to load
	var dirty = false
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        
        loadImages()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First solution!
//        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")
//
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
//        }
        
        // Second solution
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
		// find the image for this cell, and load its thumbnail
		let currentImage = items[indexPath.row % items.count]
        let original = images[indexPath.row % items.count]

        let renderRect = CGRect(origin: .zero, size: CGSize(width: 60, height: 60))
		let renderer = UIGraphicsImageRenderer(size: renderRect.size)

		let rounded = renderer.image { ctx in
//            ctx.cgContext.setShadow(offset: .zero, blur: 200, color: UIColor.black.cgColor)
//            ctx.cgContext.fillEllipse(in: CGRect(origin: .zero, size: original.size))
//            ctx.cgContext.setShadow(offset: .zero, blur: 0, color: nil)
			ctx.cgContext.addEllipse(in: renderRect)
			ctx.cgContext.clip()

            original.draw(in: renderRect)
		}

		cell.imageView?.image = rounded

		// give the images a nice shadow to make them look a bit more dramatic
		cell.imageView?.layer.shadowColor = UIColor.black.cgColor
		cell.imageView?.layer.shadowOpacity = 1
		cell.imageView?.layer.shadowRadius = 10
		cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath

		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
    }
    
    func loadImages() {
        // load all the JPEGs into our array
        let fm = FileManager.default
        if let resourcePath = Bundle.main.resourcePath {
            if let tmpItems = try? fm.contentsOfDirectory(atPath: resourcePath) {
                for item in tmpItems {
                    if item.range(of: "Large") != nil {
                        items.append(item)
                        
                        if let image = saveToCache(name: item) {
                            images.append(image)
                        } else {
                            if let thumbnail = createThumbnail(imageName: item) {
                                images.append(thumbnail)
                            }
                        }
                    }
                }
            }
            
        }

    }
    
    func createThumbnail(imageName: String) -> UIImage? {
        // Get the thumbnail image file name
        let imageRootName = imageName.replacingOccurrences(of: "Large", with: "Thumb")
        
        // Load it's path
        guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil) else { fatalError("Couldn't get Path") }
        guard let original = UIImage(contentsOfFile: path) else { fatalError("Couldn't create UIImage") }
        
        // scale down the image to save it into cache
          let renderRect = CGRect(origin: .zero, size: CGSize(width: 60, height: 60))
          let renderer = UIGraphicsImageRenderer(size: renderRect.size)
          
          let rounded = renderer.image { ctx in
              ctx.cgContext.addEllipse(in: renderRect)
              ctx.cgContext.clip()
              
              original.draw(in: renderRect)
          }
          
          saveToCache(name: imageName, image: rounded)
          return rounded
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = items[indexPath.row % items.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		navigationController!.pushViewController(vc, animated: true)
	}
    
    // challenge 3
    func saveToCache(name: String) -> UIImage? {
        let path = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile: path.path)
    }
    
    func saveToCache(name: String, image: UIImage) {
        let imagePath = getDocumentsDirectory().appendingPathComponent(name)
        if let pngData = image.pngData() {
            try? pngData.write(to: imagePath)
        }
    }
    
    // challenge 3
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
