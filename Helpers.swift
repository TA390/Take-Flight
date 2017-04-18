//
//  Helpers.swift
//  TakeFlight
//
//  Created by TA on 15/01/2017.
//  Copyright © 2017 Vanilla Studios. All rights reserved.
//

/****************************************************************************************/

import AudioToolbox
import SpriteKit

/****************************************************************************************/

func loadScene(_ scene: SKScene, _ view: SKView){
    
    scene.scaleMode = .aspectFit;
    
    view.presentScene(scene, transition: SKTransition.fade(withDuration: 0.4))
    
}

/****************************************************************************************/

struct BitMask{
    
    static let none: UInt32 = 0;
    static let bird: UInt32 = 0x1 << 0;
    static let score: UInt32 = 0x1 << 1;
    static let branch: UInt32 = 0x1 << 2;
    static let gravity: UInt32 = 0x1 << 3;
    static let boundary: UInt32 = 0x1 << 4;
    
}

/****************************************************************************************/

class Sound{
    
    private var sound: Bool
    
    private let key = "soundKey"
    
    private var scoreSoundID: SystemSoundID!
    
    private var collisionSoundID: SystemSoundID!
    
    /************************************************************************************/
    
    init(){
        
        UserDefaults.standard.register(defaults: [key : true]);
        
        sound = UserDefaults.standard.bool(forKey: key)
        
        scoreSoundID = getSoundID("score")
        
        collisionSoundID = getSoundID("colliion")
        
    }
    
    /************************************************************************************/
    
    func setButtonImage(_ button: SKSpriteNode){
        
        button.texture = SKTexture(imageNamed: sound ? "sound" : "mute");
        
    }
    
    /************************************************************************************/
    
    func toggle(_ button: SKSpriteNode){
        
        sound = !sound;
        
        setButtonImage(button);
        
        UserDefaults.standard.set(sound, forKey: key);
        
    }
    
    /************************************************************************************/
    
    func score(){
        
        AudioServicesPlaySystemSound(scoreSoundID)
        
    }
    
    /************************************************************************************/
    
    func collision(){
        
        AudioServicesPlaySystemSound(collisionSoundID);
        
    }
    
    /************************************************************************************/
    
    private func getSoundID(_ resourse: String, ext: String = "wav") -> SystemSoundID {
        
        var soundID: SystemSoundID = 0
        
        if let soundURL = Bundle.main.url(forResource: resourse, withExtension: ext) {
            
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
            
        }
        
        return soundID
        
    }
    
}

/****************************************************************************************/
