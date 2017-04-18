//
//  HighScore.swift
//  TakeFlight
//
//  Created by TA on 06/01/2017.
//  Copyright © 2017 Vanilla Studios. All rights reserved.
//

/****************************************************************************************/

import SpriteKit

/****************************************************************************************/

class HighScore{
    
    /* UserDefaults key */
    
    let key = "highScore";
    
    /************************************************************************************/
    /*
     Return true if 'score' is greater than the current high score, else return false.
     */
    func isHighScore(score: Int) -> Bool {
        
        return score > get();
        
    }
    
    /************************************************************************************/
    /*
     Return the current high score.
     */
    func get() -> Int {
        
        return UserDefaults.standard.integer(forKey: key);
        
    }
    
    /************************************************************************************/
    /*
     Set a new high score.
     */
    func set(score: Int) {
        
        if isHighScore(score: score){
            
            UserDefaults.standard.set(score, forKey: key);
            
        }
        
    }
    
}

/****************************************************************************************/
