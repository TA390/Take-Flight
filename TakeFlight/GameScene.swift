//
//  GameScene.swift
//  TakeFlight
//
//  Created by TA on 06/01/2017.
//  Copyright © 2017 Vanilla Studios. All rights reserved.
//

/****************************************************************************************/

import Social
import SpriteKit

/****************************************************************************************/

class Branch {
    
    private var minimumGap: CGFloat!
    
    var randomGap: CGFloat = 0.0
    
    private var sceneWidth: CGFloat!
    
    private var yOffset: CGFloat!
    
    private var branchImage: String!
    
    private let name = "branches"
    
    var frequency: Double = 0.0
    
    var speed: Double = 0.0
    
    
    init(_ scene: SKScene, _ bird: Bird){
        
        minimumGap = bird.size.width * 2.0
        
        randomGap = bird.size.width
        
        sceneWidth = scene.size.width
        
        yOffset = scene.size.height * 0.5
        
        reset(scene)
        
    }
    
    private func createBranch() -> SKSpriteNode {
        
        let branch = SKSpriteNode(imageNamed: branchImage)
        branch.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        branch.physicsBody = SKPhysicsBody(texture: branch.texture!, size: branch.texture!.size())
        branch.physicsBody?.categoryBitMask = BitMask.branch
        branch.physicsBody?.affectedByGravity = false
        branch.physicsBody?.isDynamic = false
        
        return branch
        
    }
    
    private func createScore() -> SKSpriteNode {
        
        let score = SKSpriteNode();
        score.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        score.size = CGSize(width: sceneWidth, height: 1);
        score.physicsBody = SKPhysicsBody(rectangleOf: score.size);
        score.physicsBody?.categoryBitMask = BitMask.score;
        score.physicsBody?.collisionBitMask = BitMask.none;
        score.physicsBody?.affectedByGravity = false;
        score.physicsBody?.isDynamic = false;
        
        return score
        
    }
    
    func removeActions(_ scene: SKScene) {
        
        scene.enumerateChildNodes(
            
            withName: name,
            
            using: {
                
                (node, error) in
                
                node.removeAllActions()
                
        }
            
        )
        
    }
    
    func reset(_ scene: SKScene) {
        
        scene.enumerateChildNodes(
            
            withName: name,
            
            using: {
                
                (node, error) in
                
                node.removeFromParent()
                
        }
            
        )
        
        setBranch("small branch")
        frequency = 1.0
        speed = 5.0
        
    }
    
    func setBranch(_ name: String) {
        
        branchImage = name
        
    }
    
    func getBranches() -> SKNode {
        
        let container = SKNode()
        container.zPosition = 1
        container.name = name
        
        let left = createBranch()
        let right = createBranch()
        right.xScale *= -1.0
        
        container.addChild(left)
        container.addChild(right)
        container.addChild(createScore())
        
        let minBranchWidth: CGFloat = 50;
        
        let gap = minimumGap + CGFloat(arc4random_uniform(UInt32(randomGap)))
        
        let minOffset = gap + minBranchWidth * 2.0
        
        let x = minBranchWidth + CGFloat(arc4random_uniform(UInt32(sceneWidth - minOffset)))
        
        left.position.x = -sceneWidth + x
        
        right.position.x = left.position.x + left.size.width + gap
        
        
        container.position.y = yOffset
        
        let moveAction = SKAction.moveTo(y: -(yOffset + left.size.height), duration: speed)
        
        let removeAction = SKAction.run { container.removeFromParent() }
        
        container.run(SKAction.sequence([moveAction, removeAction]))
        
        return container
        
    }
    
}

/****************************************************************************************/

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    private var inPlay: Bool = false
    
    private var isAlive: Bool = false
    
    private var score: Int = 0
    
    private var scoreLabel: SKLabelNode!
    
    private var level = 0.0
    
    private let midLevel = 8.0
    
    private let maxLevel = 16.0
    
    private let deltaSpeed = 0.1
    
    
    private var backgrounds = [SKSpriteNode]()
    
    private let backgroundStep = CGFloat(20.0)
    
    
    private var bird = Bird()
    
    private let sound = Sound()
    
    private let highScore = HighScore()
    
    private var branches: Branch!
    
    
    private var pausedLabel: SKLabelNode!
    
    private var pauseButton: SKSpriteNode!
    
    private var soundButton: SKSpriteNode!
    
    private var instructions: SKSpriteNode!
    
    private var gameOverOverlay: SKSpriteNode!
    
    private var restartButton: SKSpriteNode!
    
    private var backButton: SKSpriteNode!
    
    private var facebookButton: SKSpriteNode!
    
    private var twitterButton: SKSpriteNode!
    
    private var highScoreLabel: SKLabelNode!
    
    private var finalScoreLabel: SKLabelNode!
    
    
    /* HELPERS */
    /************************************************************************************/
    /*
     Reset game play
     */
    func reset(){
        
        inPlay = false
        isAlive = true
        isPaused = false
        pausedLabel.isHidden = true
        instructions.isHidden = false
        gameOverOverlay.isHidden = true
        score = 0
        scoreLabel.text = String(score)
        level = 0.0
        branches.reset(self)
        bird.position.x = 0.0
        
    }
    
    /************************************************************************************/
    /*
     Start game play
     */
    func startGame() {
        
        if inPlay == false {
            
            inPlay = true
            instructions.isHidden = true
            spawnBranches()
            bird.startFlapAnimation()
            
        }
        
        isPaused = false
        pausedLabel.isHidden = true
        
    }
    
    /************************************************************************************/
    /*
     Pause game play
     */
    func pauseGame() {
        
        isPaused = true
        pausedLabel.isHidden = false
        
    }
    
    /************************************************************************************/
    /*
     Stop game play
     */
    func stopGame() {
        
        isAlive = false
        isPaused = true
        bird.stopFlapAnimation()
        branches.removeActions(self)
        removeAllActions()
        
    }
    
    /************************************************************************************/
    /*
     Load dialog box to share the current high score on social media
     */
    func shareOn(_ view: UIView, _ type: String, prefix: String = ""){
        
        let vc = SLComposeViewController(forServiceType: type);
        
        vc?.setInitialText("\(prefix)Take Flight High Score: \(highScore.get())!");
        
        view.window?.rootViewController?.present(
            vc!,
            animated: true,
            completion: nil
        )
        
    }
    
    /************************************************************************************/
    /*
     Handle end of game play when the player collides with an obstacle
     */
    func gameOver(){
        
        stopGame()
        
        gameOverOverlay.isHidden = false
        
        if highScore.isHighScore(score: score){
            
            highScore.set(score: score)
            highScoreLabel.text = "New High Score: \(score)"
            
        } else{
            
            highScoreLabel.text = "High Score: \(highScore.get())"
            
        }
        
        finalScoreLabel.text = "Score: \(score)"
        
    }
    
    /************************************************************************************/
    /*
     Create a radial gravity instance
     */
    func radialGravity() -> SKFieldNode {
        
        /* Disable the default gravity */
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        physicsWorld.contactDelegate = self
        
        
        /* Set radial gravity */
        
        let gravity = SKFieldNode.radialGravityField()
        
        gravity.categoryBitMask = BitMask.gravity
        
        gravity.zPosition = bird.zPosition
        
        gravity.position = bird.position
        
        gravity.isEnabled = true
        
        gravity.smoothness = 2
        
        gravity.falloff = 0.2
        
        gravity.strength = 7
        
        return gravity
        
    }
    
    
    /************************************************************************************/
    /*
     Obstacles
     */
    func spawnBranches(){
        
        let sequence = SKAction.sequence([
            
            SKAction.run {
                
                DispatchQueue.global(qos: DispatchQoS.userInteractive.qosClass).async {
                    
                    let b = self.branches.getBranches()
                    
                    DispatchQueue.main.async{ self.addChild(b) }
                    
                }
                
            },
            
            SKAction.wait(forDuration: self.branches.frequency)
            
            ])
        
        self.run(SKAction.repeatForever(sequence))
        
    }
    
    /************************************************************************************/
    /*
     Collision detection
     */
    func didBegin(_ contact: SKPhysicsContact) {
        
        if isAlive {
            
            let bitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
            
            if bitMask == (BitMask.bird | BitMask.score){
                
                score += 1
                scoreLabel.text = String(score)
                sound.score()
                
                if level < maxLevel {
                    
                    level += 1
                    branches.speed -= deltaSpeed
                    
                    if level == midLevel {
                        
                        branches.randomGap /= 2
                        branches.frequency -= 0.3
                        branches.setBranch("medium branch")
                        
                    } else if level == maxLevel {
                        
                        branches.randomGap /= 2
                        branches.frequency -= 0.3
                        branches.setBranch("large branch")
                        
                    }
                }
                
            } else if bitMask == (BitMask.bird | BitMask.branch){
                
                gameOver()
                sound.collision()
                
            }
            
        }
        
    }
    
    /* END HELPERS */
    /************************************************************************************/
    
    
    
    
    /* SCENE */
    /************************************************************************************/
    /*
     Scene set up
     */
    override func didMove(to view: SKView){
        
        /* Background images */
        
        enumerateChildNodes(
            
            withName: "background",
            
            using: {
                
                (node, error) in
                self.backgrounds.append(node as! SKSpriteNode)
                
        }
            
        )
        
        
        /* Left and right boundaries */
        
        enumerateChildNodes(
            
            withName: "boundary",
            
            using: {
                
                (node, error) in
                
                let boundary = node as! SKSpriteNode
                boundary.physicsBody = SKPhysicsBody(rectangleOf: boundary.size)
                boundary.physicsBody?.categoryBitMask = BitMask.boundary
                boundary.physicsBody?.affectedByGravity = false
                boundary.physicsBody?.isDynamic = false
                
        }
            
        )
        
        
        /* Add the bird to the scene */
        
        addChild(bird)
        
        
        /* Add radial gracity field */
        
        addChild(radialGravity())
        
        
        /* Initialise all optionals */
        
        branches = Branch(self, bird)
        
        pausedLabel = childNode(withName: "pausedLabel") as! SKLabelNode
        
        pauseButton = childNode(withName: "pauseButton") as! SKSpriteNode
        
        soundButton = childNode(withName: "soundButton") as! SKSpriteNode
        
        sound.setButtonImage(soundButton)
        
        instructions = childNode(withName: "instructions") as! SKSpriteNode
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        
        gameOverOverlay = childNode(withName: "gameOverOverlay") as! SKSpriteNode
        
        restartButton = gameOverOverlay.childNode(withName: "restartButton") as! SKSpriteNode
        
        backButton = gameOverOverlay.childNode(withName: "backButton") as! SKSpriteNode
        
        facebookButton = gameOverOverlay.childNode(withName: "facebookButton") as! SKSpriteNode
        
        twitterButton = gameOverOverlay.childNode(withName: "twitterButton") as! SKSpriteNode
        
        highScoreLabel = gameOverOverlay.childNode(withName: "highScoreLabel") as! SKLabelNode
        
        finalScoreLabel = gameOverOverlay.childNode(withName: "finalScoreLabel") as! SKLabelNode
        
        
        /* Reset scene - Must be called last */
        
        reset();
        
    }
    
    /* END SCENE */
    /************************************************************************************/
    
    
    
    
    /* TOUCH EVENTS */
    /************************************************************************************/
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        if let touch = touches.first {
            
            let location = touch.location(in: self);
            
            if isAlive {
                
                if pauseButton.contains(location) {
                    
                    pauseGame()
                    
                } else if soundButton.contains(location) {
                    
                    sound.toggle(soundButton)
                    
                } else {
                    
                    startGame()
                    
                    if location.x > 0 {
                        
                        bird.flyRight()
                        
                    } else {
                        
                        bird.flyLeft()
                        
                    }
                    
                }
                
            } else {
                
                /* Restart the game */
                
                if restartButton.contains(location) {
                    
                    reset()
                    
                    return
                    
                }
                
                /* Go back to the main menu */
                
                if backButton.contains(location) {
                    
                    loadScene(MenuScene(fileNamed: "MenuScene")!, view!)
                    
                    return
                    
                }
                
                /* Share on facebook */
                
                if facebookButton.contains(location) {
                    
                    shareOn(view!, SLServiceTypeFacebook)
                    
                    return
                    
                }
                
                /* Share on twitter */
                
                if twitterButton.contains(location) {
                    
                    shareOn(view!, SLServiceTypeTwitter, prefix: "@take_flight_17 ")
                    
                    return
                    
                }
                
            }
            
        }
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?){
        
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?){
        
        if isAlive {
            
            pauseGame()
            
        }
        
    }
    
    /* TOUCH EVENTS */
    /************************************************************************************/
    
    
    
    
    /* UPDATE EVENT */
    /************************************************************************************/
    
    override func update(_ currentTime: TimeInterval){
        
        for background in backgrounds {
            
            background.position.y -= backgroundStep
            
            if(background.position.y < -self.frame.height){
                
                background.position.y += background.size.height * CGFloat(backgrounds.count)
                
            }
            
        }
        
    }
    
    /* END UPDATE EVENT */
    /************************************************************************************/
    
}
