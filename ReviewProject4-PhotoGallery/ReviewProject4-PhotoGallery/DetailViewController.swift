//
//  DetailViewController.swift
//  ReviewProject4-PhotoGallery
//
//  Created by Matheus Lenke on 29/07/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedCaption: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedCaption ?? ""
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(contentsOfFile: imageToLoad)
          
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    */

}
