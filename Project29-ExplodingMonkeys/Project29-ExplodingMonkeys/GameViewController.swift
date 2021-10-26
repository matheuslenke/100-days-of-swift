//
//  GameViewController.swift
//  Project29-ExplodingMonkeys
//
//  Created by Matheus Lenke on 25/10/21.
//

import UIKit
import SpriteKit
import GameplayKit

enum Player {
    case one, two
}

class GameViewController: UIViewController {
    var currentGame: GameScene?
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    @IBOutlet var player1ScoreLabel: UILabel!
    @IBOutlet var player2ScoreLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    
    var player1Score = 0 {
        didSet {
            player1ScoreLabel.text = "Player 1 score: \(player1Score)"
        }
    }
    var player2Score = 0 {
        didSet {
            player2ScoreLabel.text = "Player 2 score: \(player2Score)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        player1Score = 0
        player2Score = 0
        
        angleChanged(self)
        velocityChanged(self)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        angleSlider.isHidden = true
        angleLabel.isHidden = true
        
        velocitySlider.isHidden = true
        velocityLabel.isHidden = true
        
        launchButton.isHidden = true
        
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
        } else {
            playerNumber.text = "PLAYER TWO >>>"
        }
        
        angleSlider.isHidden = false
        angleLabel.isHidden = false
        
        velocitySlider.isHidden = false
        velocityLabel.isHidden = false
        
        launchButton.isHidden = false
    }
    
    func deactivateLabels() {
        DispatchQueue.main.async { [weak self] in
            self?.angleSlider.isHidden = true
            self?.angleLabel.isHidden = true
            
            self?.velocitySlider.isHidden = true
            self?.velocityLabel.isHidden = true
            
            self?.launchButton.isHidden = true
            self?.playerNumber.isHidden = true
            
            self?.player1ScoreLabel.isHidden = true
            self?.player2ScoreLabel.isHidden = true
            
        }
    }
    
    func activateLabels() {
        DispatchQueue.main.async { [weak self] in
            self?.angleSlider.isHidden = false
            self?.angleLabel.isHidden = false
            
            self?.velocitySlider.isHidden = false
            self?.velocityLabel.isHidden = false
            
            self?.launchButton.isHidden = false
            self?.playerNumber.isHidden = false
            
            self?.player1ScoreLabel.isHidden = false
            self?.player2ScoreLabel.isHidden = false
        }
    }
    
    func increaseScoreOf(player: Player) {
        if player == Player.one {
            player1Score += 1
        } else {
            player2Score += 1
        }
    }
    
    func getScore(of player: Player) -> Int {
        if player == Player.one {
            return player1Score
        } else {
            return player2Score
        }
    }
    
    func restartGame() {
        player1Score = 0
        player2Score = 0
    }
    
}

extension UIBezierPath {
    func addArrow(start: CGPoint, end: CGPoint, pointerLineLength: CGFloat, arrowAngle: CGFloat) {
        self.move(to: start)
        self.addLine(to: end)

        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) + ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle))
        let arrowLine2 = CGPoint(x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle), y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle))

        self.addLine(to: arrowLine1)
        self.move(to: end)
        self.addLine(to: arrowLine2)
    }
}
