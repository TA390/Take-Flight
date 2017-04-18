//
//  MenuScene.swift
//  TakeFlight
//
//  Created by TA on 06/01/2017.
//  Copyright © 2017 Vanilla Studios. All rights reserved.
//

/****************************************************************************************/

import SpriteKit

/****************************************************************************************/

class MenuScene: SKScene{
    
    var playButton: SKSpriteNode!
    
    /************************************************************************************/
    /*
     Scene set up.
     */
    override func didMove(to view: SKView) {
        
        /* Set the value of the high score label. */
        
        let label = childNode(withName: "highScoreLabel") as! SKLabelNode
        
        label.text = "High Score: \(HighScore().get())"
        
        
        /* Set playButton */
        
        playButton = childNode(withName: "playButton") as! SKSpriteNode
        
        
        /* Move clouds in the background */
        
        animateClouds()
        
    }
    
    /************************************************************************************/
    /*
     Load GameScene when the play button is pressed
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if playButton != nil, let touch = touches.first {
            
            if playButton.contains(touch.location(in: self)) {
                
                loadScene(GameScene(fileNamed: "GameScene")!, view!)
                
            }
            
        }
        
    }
    
    /************************************************************************************/
    /*
     Move all clouds across the screen from right to left in continuous a loop.
     */
    func animateClouds(){
        
        enumerateChildNodes(
            
            withName: "cloud",
            
            using: {
                
                (node, error) in
                
                let cloud = node as! SKSpriteNode;
                
                
                let width = self.frame.width;
                
                let start = cloud.position.x + width;
                
                let end = cloud.position.x - width;
                
                
                let move = SKAction.moveTo(x: end, duration: TimeInterval(8));
                
                let reposition = SKAction.run{ cloud.position.x = start};
                
                let sequence = SKAction.sequence([move, reposition]);
                
                
                cloud.run(SKAction.repeatForever(sequence));
                
                cloud.position.x = start;
                
        }
            
        )
        
    }
    
}

/****************************************************************************************/



