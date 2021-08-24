//
//  TargetSlot.swift
//  ReviewProject6-ShootingGallery
//
//  Created by Matheus Lenke on 22/08/21.
//

import SpriteKit

class TargetSlot: SKNode {
    var charNode: SKSpriteNode!
    var stickNode: SKSpriteNode!
    
    var isHit = false
    
    func configure(slot: Int, direction: String = "left", type targetType: Int = 1) {
        
        var sprite: SKSpriteNode!
        var stickSprite: SKSpriteNode!
        
        switch targetType {
        case 0:
            sprite = SKSpriteNode(imageNamed: "target0")
            self.name = "targetBad"
            stickSprite = SKSpriteNode(imageNamed: "stick1")
        case 1:
            sprite = SKSpriteNode(imageNamed: "target1")
            self.name = "targetGood"
            stickSprite = SKSpriteNode(imageNamed: "stick0")
        case 2:
            sprite = SKSpriteNode(imageNamed: "target2")
            self.name = "targetGood"
            stickSprite = SKSpriteNode(imageNamed: "stick2")
        case 3:
            sprite = SKSpriteNode(imageNamed: "target3")
            self.name = "targetGood"
            stickSprite = SKSpriteNode(imageNamed: "stick0")
        default:
            print("Error defining sprite")
            return;
        }
        
        
        sprite.setScale(0.5)
        var spriteX = 1200
        var moveHorizontalAction = SKAction.moveTo(x: 0, duration: 10)
        
        if (direction == "right") {
            spriteX = 0
            moveHorizontalAction = SKAction.moveTo(x: 1200, duration: 10)
        } else {
            sprite.xScale = sprite.xScale * -1;
        }
        
        switch slot {
        case 1:
            let position = CGPoint(x: spriteX, y: 225)
            sprite.position = position
            sprite.zPosition = 8
            stickSprite.position = CGPoint(x: 0, y: Int(-sprite.size.height) * 2)
        case 2:
            let position = CGPoint(x: spriteX, y: 360)
            sprite.position = position
            sprite.zPosition = 5
            stickSprite.position = CGPoint(x: 0, y: Int(-sprite.size.height) * 2)
        case 3:
            let position = CGPoint(x: spriteX, y: 450)
            sprite.position = position
            sprite.zPosition = 3
            stickSprite.position = CGPoint(x: 0, y: Int(-sprite.size.height) * 2)
        default:
            print("failed")
        }
        
        stickNode = stickSprite
        charNode = sprite

        addChild(sprite)
        sprite.addChild(stickSprite)


        let moveUpAction = SKAction.moveTo(y: sprite.position.y + 10, duration: 1)
        let moveDownAction = SKAction.moveTo(y: sprite.position.y - 10, duration: 1)
        
        let bounceUpAndDownAction = SKAction.sequence([moveUpAction, moveDownAction, moveUpAction, moveDownAction, moveUpAction, moveDownAction, moveUpAction, moveDownAction, moveUpAction, moveDownAction])
        
        sprite.run(moveHorizontalAction)
        sprite.run(bounceUpAndDownAction)
        
    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x:0, y:0, duration: 0.5)
        let sequence = SKAction.sequence([delay, hide])
        charNode.run(sequence)
        
        self.removeFromParent()
    }

}
