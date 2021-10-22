//
//  DetailViewController.swift
//  HWS-Project1
//
//  Created by Matheus Lenke on 21/06/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedTitle
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            
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
    
    @objc func shareTapped() {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        guard let imageName = selectedImage else {
            print("No image name")
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        guard let image = UIImage(data: imageData, scale: 1.0) else { return }
        let newImage = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: image.size.width , height: image.size.height).insetBy(dx: 5, dy: 5)
            ctx.cgContext.addRect(rectangle)
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 24),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.black
            ]
           
            let string = "From Storm Viewer"
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 5, y: 5, width: 200, height: 200), options: .usesLineFragmentOrigin, context: nil)
            
            // Writing with white
            let attrsSmall: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 23),
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.white
            ]
            let attributedStringWhite = NSAttributedString(string: string, attributes: attrsSmall)
           
            attributedStringWhite.draw(with: CGRect(x: 5, y: 5, width: 200, height: 200), options: .usesLineFragmentOrigin, context: nil)
        }
        guard let newImageData = newImage.pngData() else { return }
        let vc = UIActivityViewController(activityItems: [newImageData , imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
