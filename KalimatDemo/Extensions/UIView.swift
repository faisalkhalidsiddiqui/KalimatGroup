//
//  UIView.swift
//  KalimatDemo
//
//  Created by FAISAL KHALID on 22/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    
    //Animation
    
    func fadeIn(duration: TimeInterval = 2.0, delay: TimeInterval = 1.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    
    //Animation
    func fadeOut(duration: TimeInterval = 2.0, delay: TimeInterval = 1.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    
    
    // DragDrop helper
    func isOverLap(with view:UIView )->Bool{
         
         
         let frame = CGRect(x: ( self.frame.minX + self.frame.maxX ) / 2, y: ( self.frame.minY + self.frame.maxY ) / 2, width: 1.0, height: 1.0)
         return frame.intersects(view.frame)
         

     }
     
    // DragDrop helper

    
     func getAllDraggableSubviews() -> [DraggableView]{
         
         var subviews:[DraggableView] = []
         for subview in self.subviews {
             if let subview = subview as? DraggableView {
                 subviews.append(subview)
             }
             subviews.append(contentsOf: subview.getAllDraggableSubviews())
             
         }
         return subviews
     }
     
    
    // click helper

     func getAllClickableSubviews() -> [ClickableView]{
         
         var subviews:[ClickableView] = []
         for subview in self.subviews {
             if let subview = subview as? ClickableView {
                 subviews.append(subview)
             }
             subviews.append(contentsOf: subview.getAllClickableSubviews())
             
         }
         return subviews
     }
     
    // DragDrop helper

     func getAllDropableSubviews() -> [DropableView]{
         var subviews:[DropableView] = []
         for subview in self.subviews {
             
             if let subview = subview as? DropableView {
                 subviews.append(subview)
             }
             
             subviews.append(contentsOf: subview.getAllDropableSubviews())
         }
         return subviews
     }
    
    
}
