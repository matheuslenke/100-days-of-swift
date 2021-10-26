//
//  gameOverScene.swift
//  Project29-ExplodingMonkeys
//
//  Created by Matheus Lenke on 26/10/21.
//

import SpriteKit

class gameOverScene: SKScene {
    var playerWinsLabel: SKLabelNode!
    var playAgain: SKLabelNode!
    
    var playerWhoWins: Player?
    weak var viewController: GameViewController?

    override func didMove(to view: SKView) {
        createTitle()
        createPlayAgain()
        scene?.backgroundColor = .systemBlue
    }
    
    func createTitle() {
        playerWinsLabel = SKLabelNode(fontNamed: "Chalkduster")
        playerWinsLabel.horizontalAlignmentMode = .left
        playerWinsLabel.fontSize = 48
        
        guard let playerWhoWins = playerWhoWins else {
            return
        }

        if playerWhoWins == .one {
            playerWinsLabel.text = "Player one wins!"
        } else {
            playerWinsLabel.text = "Player two wins!"
        }
        addChild(playerWinsLabel)
        
        playerWinsLabel.position = CGPoint(x: 290, y: 384)
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
                let newGame = GameScene(size: self.size)
                newGame.viewController = self.viewController
                self.viewController?.currentGame = newGame
                
                newGame.currentPlayer = 1
                
                self.viewController?.activateLabels()
                
                let transition = SKTransition.fade(withDuration: 1)
                self.view?.presentScene(newGame, transition: transition)
            }
        }
    }
}
