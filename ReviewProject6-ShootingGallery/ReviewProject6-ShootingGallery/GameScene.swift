//
//  GameScene.swift
//  ReviewProject6-ShootingGallery
//
//  Created by Matheus Lenke on 22/08/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var targets = [TargetSlot]()
    var gameScore: SKLabelNode!
    
    var popupTime = 0.85
    var numRounds = 0
    
    var gameTimers = [Timer]()
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.aspectFillToSize(fillSize: view.frame.size)
        background.zPosition = -1
        addChild(background)
        
        let grass = SKSpriteNode(imageNamed: "grass-trees")
        grass.position = CGPoint(x: 512, y: 390)
        grass.zPosition = 1
        grass.aspectFillToSizeHorizontal(fillSize: view.frame.size)
        addChild(grass)
        
        let waterBg = SKSpriteNode(imageNamed: "water-bg")
        waterBg.position = CGPoint(x: 512, y: 230)
        waterBg.zPosition = 4
        waterBg.aspectFillToSizeHorizontal(fillSize: view.frame.size)
        addChild(waterBg)

        let waterFg = SKSpriteNode(imageNamed: "water-fg")
        waterFg.position = CGPoint(x: 512, y: 150)
        waterFg.zPosition = 6
        waterFg.aspectFillToSizeHorizontal(fillSize: view.frame.size)
        addChild(waterFg)
        
        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.position = CGPoint(x: 512, y: 384)
        curtains.zPosition = 100
        curtains.aspectFillToSize(fillSize: view.frame.size)
        addChild(curtains)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 600, y: 50)
        gameScore.horizontalAlignmentMode = .left
        gameScore.zPosition = 101
        gameScore.fontSize = 48
        addChild(gameScore)
        
        physicsWorld.gravity = .zero
        
        gameTimers.append(Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(createEnemy(timer:)), userInfo: ["slot": 1, "direction": "left"], repeats: true))
        gameTimers.append(Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(createEnemy(timer:)), userInfo: ["slot": 2, "direction": "right"], repeats: true))
        gameTimers.append(Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(createEnemy(timer:)), userInfo: ["slot": 3, "direction": "left"], repeats: true))
    }
    
    @objc func createEnemy(timer: Timer) {
//        guard let safeInfo = sender else { return }
        let customUserInfo = timer.userInfo as! Dictionary<String, AnyObject>
        guard let slot = customUserInfo["slot"] as? Int else { return }
        guard let direction = customUserInfo["direction"] as? String else { return }
        let targetType = Int.random(in: 0...3)
        let target = TargetSlot()
        target.configure(slot: slot, direction: direction, type: targetType)

        addChild(target)
        targets.append(target)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let targetSlot = node as? TargetSlot else { continue }
            if targetSlot.isHit { continue }
            targetSlot.hit()
            
            if let smokeParticles = SKEmitterNode(fileNamed: "Explosion") {
                smokeParticles.position = CGPoint(x: targetSlot.charNode.position.x, y: targetSlot.charNode.position.y + 20)
                smokeParticles.zPosition = 2
                addChild(smokeParticles)
            }

            if node.name == "targetBad" {
                // they shouldn't have hit a bad target
                score -= 5
            } else if node.name == "targetGood" {
                // they should have shot this one
//                whackSlot.showBadSmoke()
                targetSlot.charNode.xScale = 0.60
                targetSlot.charNode.yScale = 0.60
                score += 1
                
                
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension SKSpriteNode {

    func aspectFillToSize(fillSize: CGSize) {

        if texture != nil {
            self.size = texture!.size()

            let verticalRatio = fillSize.height / self.texture!.size().height
            let horizontalRatio = fillSize.width /  self.texture!.size().width

            let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio

            self.setScale(scaleRatio)
        }
    }
    
    func aspectFillToSizeHorizontal(fillSize: CGSize) {

        if texture != nil {
            self.size = texture!.size()

//            let verticalRatio = fillSize.height / self.texture!.size().height
            let horizontalRatio = fillSize.width /  self.texture!.size().width
            self.setScale(horizontalRatio)
        }
    }

}

struct customUserInfo {
    var slot: Int
    var direction: String
}
