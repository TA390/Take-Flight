//
//  GameViewController.swift
//  TakeFlight
//
//  Created by TA on 06/01/2017.
//  Copyright © 2017 Vanilla Studios. All rights reserved.
//

/****************************************************************************************/

import SpriteKit
import UIKit

/****************************************************************************************/

class GameViewController: UIViewController {
    
    /************************************************************************************/
    /*
     Load MenuScene
     */
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
        if let view = self.view as! SKView? {
            
            loadScene(MenuScene(fileNamed: "MenuScene")!, view)
            
            view.showsFPS = false
            view.showsPhysics = false
            view.showsNodeCount = false
            view.ignoresSiblingOrder = true
            
        }
        
    }
    
    /************************************************************************************/
    /*
     Disable screen rotation
     */
    override var shouldAutorotate: Bool {
        
        return false
        
    }
    
    /************************************************************************************/
    /*
     Enable portrait mode only
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
        
    }
    
    /************************************************************************************/
    /*
     Remove the status bar
     */
    override var prefersStatusBarHidden: Bool {
        
        return true
        
    }
    
    /************************************************************************************/
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
}
