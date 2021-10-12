//
//  GameOverScene.swift
//  Project23-FruitNinja
//
//  Created by Matheus Lenke on 12/10/21.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var gameOver: SKLabelNode!
    var playAgain: SKLabelNode!

    override func didMove(to view: SKView) {
        createTitle()
        createPlayAgain()
        scene?.backgroundColor = .systemRed
    }
    
    func createTitle() {
        gameOver = SKLabelNode(fontNamed: "Chalkduster")
        gameOver.horizontalAlignmentMode = .left
        gameOver.fontSize = 48
        gameOver.text = "Game Over!"
        addChild(gameOver)
        
        gameOver.position = CGPoint(x: 312, y: 384)
    }
    
    func createPlayAgain() {
        playAgain = SKLabelNode(fontNamed: "Chalkduster")
        playAgain.horizontalAlignmentMode = .left
        playAgain.fontSize = 32
        playAgain.text = "Play again"
        playAgain.name = "playAgain"
        addChild(playAgain)
        
        playAgain.position = CGPoint(x: 390, y: 284)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKLabelNode in nodesAtPoint {
            if node.name == "playAgain" {
                let transition = SKTransition.fade(withDuration: 1)
                if let gameScene = SKScene(fileNamed: "GameScene") {
                    gameScene.scaleMode = .aspectFit
                    self.view?.presentScene(gameScene, transition: transition)
                }
            }
        }
    }
}
