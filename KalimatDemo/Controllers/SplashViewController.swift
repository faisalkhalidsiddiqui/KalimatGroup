//
//  SplashViewController.swift
//
//  Created by FAISAL KHALID on 19/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var logoBlurred: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Sound.play(file: "electric-sfx", fileExtension: ".mp3", numberOfLoops: -1, volume: 1.0)
        animate()
        
        moveToNextScene()
    }
    
    
    func moveToNextScene(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            Sound.stopAll()
            let controller = self.storyboard?.instantiateViewController(identifier: "room")
            self.present(controller!, animated: false, completion: nil)
            
        }
    }
    func animate(){
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.logo.alpha = 0.75
        }){ completed in
            
            UIView.animate(withDuration: 1.0,animations: {
                self.logo.alpha = 1.0
                
            }){
                completed in
                
                self.animate()
            }
            
        }
    }
    
}
