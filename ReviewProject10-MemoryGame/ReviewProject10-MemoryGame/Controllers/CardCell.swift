//
//  CollectionViewCell.swift
//  ReviewProject10-MemoryGame
//
//  Created by Matheus Lenke on 27/10/21.
//

import UIKit

enum State {
    case front
    case back
}

class CardCell: UICollectionViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var backView: UIImageView!
    
    
    var selectedWord: String?
    var selectedLanguage: String?
    var originalWord: WordItem?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        renderFrontFace()
    }
    
    func renderFrontFace() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 130, height: 150))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 130, height: 150)
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.move(to: CGPoint(x: 55, y: 75))
            ctx.cgContext.addLine(to: CGPoint(x: 65, y: 90))
            ctx.cgContext.addLine(to: CGPoint(x: 75, y: 75))
            ctx.cgContext.addLine(to: CGPoint(x: 65, y: 60))
            ctx.cgContext.addLine(to: CGPoint(x: 55, y: 75))
            
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(1)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        imageView.image = image
    }
    
    func flipCard(isSelected cardSelected: Bool) {
        if cardSelected {
            perform(#selector(flipToFront), with: nil)
        } else {
            perform(#selector(flipToBack), with: nil)
        }
    }
    
    func renderBackFace() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 130, height: 150))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 130, height: 150)
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 15),
                .paragraphStyle: paragraphStyle
            ]
            if let safeWord = selectedWord {
                let attributedString = NSAttributedString(string: safeWord, attributes: attrs)
                attributedString.draw(with: CGRect(x: 0 , y: 65, width: 130, height: 40), options: .usesLineFragmentOrigin, context: nil)
                
                let languageAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 11),
                    .paragraphStyle: paragraphStyle,
                    .foregroundColor: UIColor.gray
                ]
                
                let languageString = NSAttributedString(string: selectedLanguage!, attributes: languageAttrs)
                languageString.draw(with: CGRect(x: 0 , y: 120, width: 130, height: 40), options: .usesLineFragmentOrigin, context: nil)
            }
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        backView.image = image
        backView.isHidden = true
    }
    
    func showCorrectFace(isSelected: Bool) {
        if isSelected {
            imageView.isHidden = true
            backView.isHidden = false
        } else {
            imageView.isHidden = false
            backView.isHidden = true
        }
    }
    
    @objc fileprivate func flipToBack() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: backView, duration: 0.4, options: transitionOptions, animations: {
            self.backView.isHidden = true
        })
        
        UIView.transition(with: imageView, duration: 0.4, options: transitionOptions, animations: {
            self.imageView.isHidden = false
        })
    }
    
    @objc fileprivate func flipToFront() {
        let transitionOptionsLeft: UIView.AnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]

        UIView.transition(with: imageView, duration: 0.4, options: transitionOptionsLeft, animations: {
            self.imageView.isHidden = true
        })
        
        UIView.transition(with: backView, duration: 0.4, options: transitionOptionsLeft, animations: {
            self.backView.isHidden = false
        })

    }

    
}
