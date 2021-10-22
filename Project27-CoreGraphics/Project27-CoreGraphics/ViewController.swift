//
//  ViewController.swift
//  Project27-CoreGraphics
//
//  Created by Matheus Lenke on 20/10/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        drawEmoji()
//        drawRectangle()
        drawTwin()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        if currentDrawType > 5 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
            
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerboard()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
            
        case 5:
            drawImagesAndText()
            
        case 6: // Challenge 1
            drawEmoji()
        case 7: // Challenge 2
            drawTwin()
            
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // Drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // Drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // Drawing code
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // Drawing code
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // Drawing code
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
                
            }
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            // Drawing code
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
           
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }

    
    func drawEmoji() {
        let imgHeight = 512
        let imgWidth = 512
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let faceWidth = imgWidth
            let faceHeight = imgWidth
            let faceInsets: CGFloat = 20

            drawFace(ctx: ctx.cgContext, width: faceWidth, height: faceHeight, insets: faceInsets, startX: 0, startY: 0, fillColor: UIColor.yellow.cgColor, strokeColor: UIColor.orange.cgColor)

            let eyeHorizontalMargin: CGFloat = 130
            let eyeTopMargin: CGFloat = 150
            let eyeWidth = 60
            let eyeHeight = 70

            let leftEyeStartX = eyeHorizontalMargin
            let leftEyeStartY = eyeTopMargin
            drawEye(ctx: ctx.cgContext, width: eyeWidth, height: eyeHeight, startX: leftEyeStartX, startY: leftEyeStartY, color: UIColor.orange.cgColor)

            let rightEyeStartX = CGFloat(imgWidth) - CGFloat(eyeWidth) - eyeHorizontalMargin
            let rightEyeStartY = eyeTopMargin
            drawEye(ctx: ctx.cgContext, width: eyeWidth, height: eyeHeight, startX: rightEyeStartX, startY: rightEyeStartY, color: UIColor.orange.cgColor)

            let mouthWidth = 260
            let mouthHeight = 200
            let mouthStartx = CGFloat((imgWidth - mouthWidth) / 2)
            let mouthStarty = CGFloat(230)

            drawMouth(ctx: ctx.cgContext, width: mouthWidth, height: mouthHeight, startX: mouthStartx, startY: mouthStarty, color: UIColor.orange.cgColor)
            
            let tearWidth = 70
            let tearHeight = 200
            
            drawTear(ctx: ctx.cgContext, width: tearWidth, height: tearHeight, startX: leftEyeStartX - 10, startY: leftEyeStartY + 30, color: UIColor.blue.cgColor, rotateBy: CGFloat.pi / 4)
            drawTear(ctx: ctx.cgContext, width: tearWidth, height: tearHeight, startX: rightEyeStartX + 10, startY: rightEyeStartY + 80, color: UIColor.blue.cgColor, rotateBy: -(.pi / 4))
        }
        
        imageView.image = image
    }
    
    // challenge 1
    func drawFace(ctx: CGContext, width: Int, height: Int, insets: CGFloat, startX: CGFloat, startY: CGFloat, fillColor: CGColor, strokeColor: CGColor) {
        let face = CGRect(x: 0, y: 0, width: width, height: height).insetBy(dx: insets, dy: insets)
        
        ctx.setFillColor(UIColor.yellow.cgColor)
        ctx.setStrokeColor(UIColor.orange.cgColor)
        ctx.setLineWidth(5)
        
        ctx.translateBy(x: startX, y: startY)
        ctx.addEllipse(in: face)
        ctx.drawPath(using: .fillStroke)
        ctx.translateBy(x: -startX, y: -startY)
    }
    
    // challenge 1
    func drawEye(ctx: CGContext, width: Int, height: Int, startX: CGFloat, startY: CGFloat, color: CGColor) {
        let eye = CGRect(x: 0, y: 0, width: width, height: height)

        ctx.setFillColor(color)

        ctx.translateBy(x: startX, y: startY)
        ctx.addEllipse(in: eye)
        ctx.drawPath(using: .fill)
        ctx.translateBy(x: -startX, y: -startY)
    }
    
    // challenge 1
    func drawMouth(ctx: CGContext, width: Int, height: Int, startX: CGFloat, startY: CGFloat, color: CGColor) {
        let mouth = CGRect(x: 0, y: 0, width: width, height: height)
        
        
        ctx.setFillColor(color)

        ctx.translateBy(x: startX, y: startY)
        ctx.addEllipse(in: mouth)
        ctx.drawPath(using: .fill)
        ctx.translateBy(x: -startX, y: -startY)
        
        let mouthAuxWidth = Int(Double(width) * 1.2)
        let mouthAuxX = CGFloat((512 - mouthAuxWidth) / 2)
        ctx.setFillColor(UIColor.yellow.cgColor)
        let face = CGRect(x: 0, y: 0, width: mouthAuxWidth, height: height / 2)
        ctx.translateBy(x: mouthAuxX, y: startY)
        ctx.addEllipse(in: face)
        ctx.drawPath(using: .fill)
        
        ctx.translateBy(x: -mouthAuxX, y: -startY)
        
    }
    
    // challenge 1
    func drawTear(ctx: CGContext, width: Int, height: Int, startX: CGFloat, startY: CGFloat, color: CGColor, rotateBy: CGFloat ) {
        let tear = CGRect(x: 0, y: 0, width: width, height: height)

        ctx.setFillColor(color)

        ctx.translateBy(x: startX, y: startY)
        ctx.rotate(by: rotateBy)
        ctx.addEllipse(in: tear)
        ctx.drawPath(using: .fill)
        
        ctx.rotate(by: -rotateBy)
        ctx.translateBy(x: -startX, y: -startY)
    }
    
    // Challenge 2
    func drawTwin() {
        let imgHeight = 512
        let imgWidth = 512
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        let center = imgHeight / 2
        
        let image = renderer.image { ctx in
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(5)
            
            // Writing T
            let TStartingX = 70
            ctx.cgContext.move(to: CGPoint(x: TStartingX, y: center - 50))
            ctx.cgContext.addLine(to: CGPoint(x: TStartingX + 50, y: center - 50) )
            ctx.cgContext.move(to: CGPoint(x: TStartingX + 25, y: center - 50))
            ctx.cgContext.addLine(to: CGPoint(x: TStartingX + 25, y: center + 50) )
            
            // Writing W
            let WStartingX = TStartingX + 100
            ctx.cgContext.move(to: CGPoint(x: WStartingX, y: center - 50))
            ctx.cgContext.addLine(to: CGPoint(x: WStartingX + 15, y: center + 50) )
            ctx.cgContext.addLine(to: CGPoint(x: WStartingX + 30, y: center - 50) )
            ctx.cgContext.addLine(to: CGPoint(x: WStartingX + 45, y: center + 50) )
            ctx.cgContext.addLine(to: CGPoint(x: WStartingX + 60, y: center - 50) )
            
            // Writing I
            let IStartingX = WStartingX + 100
            ctx.cgContext.move(to: CGPoint(x: IStartingX, y: center - 50))
            ctx.cgContext.addLine(to: CGPoint(x: IStartingX + 50, y: center - 50) )
            ctx.cgContext.move(to: CGPoint(x: IStartingX + 25, y: center - 50))
            ctx.cgContext.addLine(to: CGPoint(x: IStartingX + 25, y: center + 50) )
            ctx.cgContext.move(to: CGPoint(x: IStartingX, y: center + 50))
            ctx.cgContext.addLine(to: CGPoint(x: IStartingX + 50, y: center + 50) )
            
            // Writing N
            let NStartingX = IStartingX + 100
            ctx.cgContext.move(to: CGPoint(x: NStartingX, y: center + 50))
            ctx.cgContext.addLine(to: CGPoint(x: NStartingX , y: center - 50) )
            ctx.cgContext.addLine(to: CGPoint(x: NStartingX + 40, y: center + 50) )
            ctx.cgContext.addLine(to: CGPoint(x: NStartingX + 40, y: center - 50) )
            
                               
            
            
            ctx.cgContext.drawPath(using: .stroke)
        }
        
        imageView.image = image
    }
}

