//
//  Bird.swift
//  TakeFlight
//
//  Created by TA on 06/01/2017.
//  Copyright © 2017 Vanilla Studios. All rights reserved.
//

/****************************************************************************************/

import SpriteKit

/****************************************************************************************/

class Bird: SKSpriteNode{
    
    private let force = 30.0
    
    private var textures = [SKTexture]()
    
    private var dynamicTexture = SKSpriteNode()
    
    private var flapAnimation: SKAction!
    
    
    init(){
        
        let birdSize = CGSize(width: 70.0, height: 70.0)
        super.init(texture: nil, color: UIColor.clear, size: birdSize)
        
        
        name = "bird"
        zPosition = 5.0
        position = CGPoint(x: 0, y: 0)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        size = birdSize
        physicsBody = SKPhysicsBody(circleOfRadius: birdSize.height * 0.5)
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = true
        physicsBody?.categoryBitMask = BitMask.bird
        physicsBody?.contactTestBitMask = BitMask.branch | BitMask.score
        physicsBody?.collisionBitMask = BitMask.branch | BitMask.boundary
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.linearDamping = 4
        physicsBody?.density = 0.4
        
        
        /* Textures */
        
        for i in 0...3 {
            
            textures.append(SKTexture(imageNamed: name! + String(i)))
            
        }
        for i in (0...2).reversed() {
            
            textures.append(SKTexture(imageNamed: name! + String(i)))
            
        }
        dynamicTexture.texture = textures[0]
        dynamicTexture.size = (dynamicTexture.texture?.size())!
        let y = (size.height - dynamicTexture.size.height) * 0.5
        dynamicTexture.position = CGPoint(x: 0, y: y)
        addChild(dynamicTexture)
        
        
        flapAnimation = SKAction.repeatForever(
            SKAction.animate(with: textures, timePerFrame: 0.1, resize: true, restore: true)
        )
        dynamicTexture.run(flapAnimation, withKey: "flapAnimation")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    func resetTexture() {
        
        dynamicTexture.texture = textures[0];
        
    }
    
    func flyRight(){
        
        physicsBody?.applyImpulse(CGVector(dx: force, dy: 0))
        
    }
    
    func flyLeft(){
        
        physicsBody?.applyImpulse(CGVector(dx: -force, dy: 0))
        
    }
    
    func startFlapAnimation(){
        
        flapAnimation.speed = 1
        
    }
    
    func stopFlapAnimation(){
        
        flapAnimation.speed = 0
        
    }
    
}
