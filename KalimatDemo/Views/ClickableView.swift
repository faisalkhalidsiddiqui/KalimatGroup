//
//  ClickableView.swift
//  katibaJoystic
//
//  Created by FAISAL KHALID on 13/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import UIKit

class ClickableView: UIView {
    
    var delegate:ClickableViewListener?

    
    
    func onClickableViewBtnClicked(){
        
        if  self.isUserInteractionEnabled && !self.isHidden {
            
            self.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.isUserInteractionEnabled = true
            }
            
            delegate?.onClickableViewBtnClicked(sender: self)
        }
        

    }
    
}


protocol ClickableViewListener {
    func onClickableViewBtnClicked(sender:ClickableView)
}
