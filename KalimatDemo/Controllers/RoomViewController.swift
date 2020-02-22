//
//  RoomViewController.swift
//
//  Created by FAISAL KHALID on 17/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import UIKit
import AVFoundation
class RoomViewController: JoystickViewController,ClickableViewListener {
    
    @IBOutlet weak var highlightText: UILabel!
    @IBOutlet weak var nextButton: ClickableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.delegate = self
        Sound.play(file: "background-sound", fileExtension: "aiff", numberOfLoops: -1,volume: 0.05)
        
        let textHighlighter =  TextHighlighter(text: highlightText, audioFileName: "sentence-01",audioFileExtension: "mp4" ,seqFileName: "sentence-01")
        textHighlighter.start()
    }
    
    
    func onClickableViewBtnClicked(sender: ClickableView) {
        if sender == nextButton {
            let controller = self.storyboard?.instantiateViewController(identifier: "worksheet", creator: nil)
            controller?.modalPresentationStyle = .fullScreen
            Sound.stopAll()
            self.present(controller!, animated: false, completion: nil)            
        }
    }
    
    
}
