//
//  ViewController.swift
//  ReviewProject9-MemeGenerator
//
//  Created by Matheus Lenke on 23/10/21.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    var selectedImage: UIImage?
    var upperComment: String?
    var bottomComment: String?
    var finalImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Meme Generator"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addNewPicture))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }

    @objc func addNewPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        selectedImage = image
        showCaptionAlert()
    }
    
    func showCaptionAlert() {
        let ac = UIAlertController(title: "Insert text", message: "Insert the text of your meme to show at the top of the image and at the bottom", preferredStyle: .alert)
        ac.addTextField(configurationHandler: .none)
        ac.addTextField(configurationHandler: .none)
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
            self?.upperComment = ac?.textFields?[0].text
            self?.bottomComment = ac?.textFields?[1].text
            self?.setImage()
            
        })
        present(ac, animated: true)
    }
    
    func setImage() {
        guard let safeImage = selectedImage else { return }
        let imageSize = safeImage.size
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        
        let newImage = renderer.image { ctx in
            let sidesLength = imageSize.width + imageSize.height
            let fontSize = sidesLength / 30
            safeImage.draw(at: CGPoint(x: 0, y: 0))
            let margin = 32
            let textWidth = Int(safeImage.size.width) - (margin * 2)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "HelveticaNeue-Bold", size: fontSize)!,
                .paragraphStyle: paragraphStyle,
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -2,
            ]
            
            // Writes the top Image
            if let topString = self.upperComment {
                let textHeight = computeTextHeight(for: topString, attributes: attrs, width: textWidth)
                let attributedString = NSAttributedString(string: topString, attributes: attrs)
                attributedString.draw(with: CGRect(x: margin, y: margin, width: textWidth, height: textHeight), options: .usesLineFragmentOrigin, context: nil)
                
            }
            
            if let bottomString = self.bottomComment {
                let textHeight = computeTextHeight(for: bottomString, attributes: attrs, width: textWidth)
                let attributedString = NSAttributedString(string: bottomString, attributes: attrs)
                attributedString.draw(with: CGRect(x: margin, y: Int(imageSize.height) - (textHeight + margin), width: textWidth, height: textHeight), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        imageView.image = newImage
        finalImage = newImage
        imageView.contentMode = .scaleAspectFit
    }
    
    func drawText(text: String, x: Int, y: Int, width: Int, height: Int, rendererSize: CGSize) {
        
    }
    
    func computeTextHeight(for text: String, attributes: [NSAttributedString.Key : Any], width: Int) -> Int {
        let nsText = NSString(string: text)
        let size = CGSize(width: CGFloat(width), height: .greatestFiniteMagnitude)
        let textRect = nsText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        return Int(ceil(textRect.size.height))
    }
    
    @IBAction func changeTopTextTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Insert text", message: "Insert the text that will go at the top of your image", preferredStyle: .alert)
        ac.addTextField(configurationHandler: .none)
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
            self?.upperComment = ac?.textFields?[0].text
            self?.setImage()
        })
        present(ac, animated: true)
    }
    
    @IBAction func changeBottomTextTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Insert text", message: "Insert the text that will go at the bottom of your image", preferredStyle: .alert)
        ac.addTextField(configurationHandler: .none)
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
            self?.bottomComment = ac?.textFields?[0].text
            self?.setImage()
        })
        present(ac, animated: true)
    }
    
    
    @objc func shareTapped() {
        if let safeImage = finalImage {
            // Share item
            guard let newImageData = safeImage.pngData() else { return }
            let imageName = "GeneratedMeme.jpg"
            let vc = UIActivityViewController(activityItems: [newImageData, imageName], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        } else {
            let ac = UIAlertController(title: "Error", message: "No picture to share found!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

}

