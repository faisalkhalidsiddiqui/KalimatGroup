//
//  DropableView.swift
//  katibaJoystic
//
//  Created by FAISAL KHALID on 10/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import UIKit

class DropableView: UIView {
    public var id:Int = -1
    var delegate:DropableViewListener?

    @IBOutlet var contentView: UIView!
    var draggableView:DraggableView?
    var word:String?
    
    
    
    func hasDraggableView()->Bool{
        if draggableView != nil {
            return true
        }
        return false
    }
    
    func removeDraggableView(){
        self.draggableView = nil
    }
    
    func setDraggableView(view:DraggableView){
        self.draggableView = view
        self.delegate?.onDraggableViewDropped(dropableView: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func commonInit(frame:CGRect,word:String) {
        Bundle.main.loadNibNamed("DropableView", owner: self, options: nil)
        contentView.fixInView(self)
        self.word = word
        self.layer.zPosition = 2
        self.frame = frame
        
    }
    
    
    func isValidBox()->Bool{
        if hasDraggableView() {
            if self.draggableView!.word! == word! && word! != "" {
                return true
            }
        }
        return false
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

protocol DropableViewListener {
    func onDraggableViewDropped(dropableView:DropableView)
}
