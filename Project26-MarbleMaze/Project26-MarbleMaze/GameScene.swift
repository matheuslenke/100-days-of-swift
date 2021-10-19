//
//  GameScene.swift
//  Project26-MarbleMaze
//
//  Created by Matheus Lenke on 17/10/21.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    var levels = [1]
    var currentLevelPosition = 0
    var currentPlayerPosition = CGPoint(x: 96, y: 672)
    var currentNodes = [SKSpriteNode]()
    
    var teleportNodeA: SKSpriteNode!
    var teleportNodeB: SKSpriteNode!
    var isTeleporting = false
    
    var motionManager: CMMotionManager?
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var winLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    enum CollisionTypes: UInt32 {
        case player = 1
        case wall = 2
        case star = 4
        case vortex = 8
        case finish = 16
        case teleport = 32
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 30)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
        
        loadLevel()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func loadLevel() {
        guard let levelURL = Bundle.main.url(forResource: "level\(levels[currentLevelPosition])", withExtension: "txt") else { return }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not find level\(levels[currentLevelPosition]).txt in the app bundle")
        }
        
        var lines = levelString.components( separatedBy: "\n")
        for (row, line) in lines.enumerated() {
            if line == "" {
                lines.remove(at: row)
            }
        }
        
        for (row, line) in lines.reversed().enumerated() {
            for(column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32 )
                
                if letter == "x" {
                    loadWall(in: position)
                    
                } else if letter == "v" {
                   loadVortex(in: position)
                    
                } else if letter == "s" {
                   loadStar(in: position)
                    
                } else if letter == "f" {
                   loadFinish(in: position)
        
                } else if letter == " " {
                    // Empty space, do nothing
                } else if letter == "p" {
                    createPlayer(in: position)
                    currentPlayerPosition = position
                } else if letter == "t" {
                    loadTeleport(in: position, type: "A")
                } else if letter == "T" {
                    loadTeleport(in: position, type: "B")
                } else {
                    fatalError("Uknown level letter: \(letter)")
                }
            }
        }
    }
    
    func loadWall(in position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "block")
        node.position = position
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        node.physicsBody?.isDynamic = false
        
        addChild(node)
        currentNodes.append(node)
    }
    
    func loadVortex(in position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "vortex"
        node.position = position
        node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        
        addChild(node)
        currentNodes.append(node)
    }
    
    func loadStar(in position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "star")
        node.name = "star"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
        currentNodes.append(node)
    }
    
    func loadFinish(in position: CGPoint) {
        let node = SKSpriteNode(imageNamed: "finish")
        node.name = "finish"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        
        node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
        currentNodes.append(node)
    }
    
    func loadTeleport(in position: CGPoint, type: String) {
        let node = SKSpriteNode(imageNamed: "vortex")
        node.name = "teleport\(type)"
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        if let emitter = SKEmitterNode(fileNamed: "Teleport") {
            emitter.zPosition = 1
            node.addChild(emitter)
        }
        
        node.physicsBody?.categoryBitMask = CollisionTypes.teleport.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        addChild(node)
        currentNodes.append(node)
        
        if type == "A" {
            teleportNodeA = node
        } else {
            teleportNodeB = node
        }
            
    }
    
    func createPlayer(in position: CGPoint) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        addChild(player)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -20, dy: accelerometerData.acceleration.x * 20)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
        
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) {
                [weak self] in
                guard let playerPosition = self?.currentPlayerPosition else { return }
                self?.createPlayer(in: playerPosition)
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            // next level!
            if currentLevelPosition + 1 == levels.count {
                winLabel = SKLabelNode(fontNamed: "Chalkduster")
                winLabel.text = "You win!"
                winLabel.horizontalAlignmentMode = .left
                winLabel.position = CGPoint(x: 400, y: 384)
                winLabel.zPosition = 2
                addChild(winLabel)
                
                self.isPaused = true
            } else {
                currentLevelPosition += 1
                player.removeFromParent()
                for node in currentNodes {
                    node.removeFromParent()
                }
                loadLevel()
            }
        } else if node.name == "teleportA" && isTeleporting == false {
            isTeleporting = true
            let move = SKAction.move(to: teleportNodeB.position, duration: 0.25)
            let scaleDown = SKAction.scale(to: 0.0001, duration: 0.25)
            let scaleUp = SKAction.scale(to: 1, duration: 0.25)
            let changePhysics = SKAction.run {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            }
            let sequence = SKAction.sequence([scaleDown, changePhysics, move, scaleUp])
            
            player.run(sequence) {
                [weak self] in
                self?.isTeleporting = false
            }
        } else if node.name == "teleportB" && isTeleporting == false {
            isTeleporting = true
            let move = SKAction.move(to: teleportNodeA.position, duration: 0.25)
            let scaleDown = SKAction.scale(to: 0.0001, duration: 0.25)
            let scaleUp = SKAction.scale(to: 1, duration: 0.25)
            let changePhysics = SKAction.run {
                self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            }
            let sequence = SKAction.sequence([scaleDown, changePhysics, move, scaleUp])
            
            player.run(sequence) {
                [weak self] in
                self?.isTeleporting = false
            }
        }
    }
    
}
