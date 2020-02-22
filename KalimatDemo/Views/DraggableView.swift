//
//  DraggableView.swift
//  katibaJoystic
//
//  Created by FAISAL KHALID on 09/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import UIKit

class DraggableView: UIView {
    
    
    public var id:Int = -1
    public var isMoving:Bool = false
    var initialCenterPoint:CGPoint?
    var word:String?
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var label: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func commonInit(frame:CGRect, word:String) {
        Bundle.main.loadNibNamed("DraggableView", owner: self, options: nil)
        contentView.fixInView(self)
        self.frame = frame
        self.layer.zPosition = 3
        self.label.text = word
        self.word = word
    }
    
    
    
    public func updateFrame(view:UIView){
        if initialCenterPoint == nil {
            initialCenterPoint = self.center
        }
        
        
        self.center = view.center
        isMoving = true
    }
    

    
}


extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    
}
