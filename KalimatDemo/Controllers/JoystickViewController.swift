//
//  ViewController.swift
//
//  Created by FAISAL KHALID on 09/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//


// 0 - up , 1 -down , 2 - left , 3- right

import UIKit

class JoystickViewController: UIViewController {
    
    @IBOutlet weak var cursor: UIImageView!
    @IBOutlet weak var joystickKeypad: UIButton!
    @IBOutlet weak var joystickXButton: UIButton!
     @IBOutlet weak var joystickView: UIView!
    var draggableViews:[DraggableView] = []
    var dropableViews:[DropableView] = []
    var clickableViews:[ClickableView] = []
    var iskeyDown = false
    var isXPressed = false
    var keyCode = -1;
    let joystickSpeed:CGFloat = 5
    
    @objc func onXButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            
            isXPressed = !isXPressed
            if !isXPressed {
                for subview in draggableViews {
                    
                    subview.isMoving = false
                    
                    DispatchQueue.main.async {
                        subview.contentView.backgroundColor = UIColor.clear
                    }
                    
                }
            }
            
            
            if isXPressed {
                for subview in draggableViews {
                    
                    
                    let frame = CGRect(x: ( cursor.frame.minX + cursor.frame.maxX ) / 2, y: ( cursor.frame.minY + cursor.frame.maxY ) / 2, width: 1.0, height: 1.0)
                    
                    
                    if frame.intersects(subview.frame){
                        DispatchQueue.main.async {
                            subview.contentView.backgroundColor = UIColor.blue
                        }
                        
                    }
                    
                }
                
                
                for subview in clickableViews {
                    
                    
                    let frame = CGRect(x: ( cursor.frame.minX + cursor.frame.maxX ) / 2, y: ( cursor.frame.minY + cursor.frame.maxY ) / 2, width: 1.0, height: 1.0)
                    if frame.intersects(subview.frame){
                        subview.onClickableViewBtnClicked()
                    }
                }
                
            }
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cursor.layer.zPosition = 10
        
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        longGesture.minimumPressDuration = 0
        joystickKeypad.addGestureRecognizer(longGesture)
        
        
        
        let longGestureXButton = UILongPressGestureRecognizer(target: self, action: #selector(self.onXButtonLongPressed(_:)))
        longGestureXButton.minimumPressDuration = 0
        
        joystickXButton.addGestureRecognizer(longGestureXButton)
        
        
         Timer.scheduledTimer(timeInterval: 0.02,
                                          target: self,
                                          selector: #selector(self.onFrameUpdate),
                                          userInfo: nil,
                                          repeats: true)
        
    }
    
    @objc func onFrameUpdate(){
        
        draggableViews = self.view.getAllDraggableSubviews()
        
        clickableViews = self.view.getAllClickableSubviews()
        
        dropableViews = self.view.getAllDropableSubviews()
        
        cursorFrameUpdate()
        
        if !isXPressed{
            
            for subview in draggableViews {
                
                var isOverlapped = false
                
                for dropView in self.dropableViews {
        
                        if subview.isOverLap(with: dropView) && !dropView.hasDraggableView() {
                            dropView.layer.zPosition = 1
                            subview.layer.zPosition = 2
                            subview.updateFrame(view: dropView)
                            
                            subview.frame.origin.y = dropView.frame.maxY - subview.bounds.height - 10.0
                            
                            
                            subview.isMoving = false
                            dropView.setDraggableView(view: subview)
                            
                            
                            var allDropableConsumed = true
                            
                            
                            //check for all droppable object consumed by draggable objects
                            for dropView in dropableViews {
                                if !dropView.hasDraggableView() {
                                    allDropableConsumed = false
                                }
                            }
                            
                            if allDropableConsumed {
                                onAllDropableConsumed()
                            }
                            
                        }
                        
                        
                        if subview.isOverLap(with: dropView) && dropView.draggableView == subview{
                            isOverlapped = true
                            
                        }
                    
                    
                    
                }
                
                if !isOverlapped {
                    if let center = subview.initialCenterPoint {
                        subview.center = center
                        subview.isMoving = false
                        
                        
                    }
                    
                }
                
            }
            
            
        }
        
    }
    
    
    @objc func cursorFrameUpdate(){
        
        
        let initialX = self.cursor.frame.origin.x
        let initialY = self.cursor.frame.origin.y
        
        if self.cursor.frame.origin.y <= 0 {
            self.cursor.frame.origin.y = 0
        }
        
        if self.cursor.frame.origin.x <= 0 {
            self.cursor.frame.origin.x = 0
        }
        
        
        if self.cursor.frame.origin.x > self.view.bounds.width - 20 {
            self.cursor.frame.origin.x  = self.view.bounds.width - 20
        }
        
        if self.cursor.frame.origin.y > self.view.bounds.height - 20 {
            self.cursor.frame.origin.y  = self.view.bounds.height - 20
        }
        
        if iskeyDown{
            
            if keyCode == 0 {
                
                self.cursor.frame.origin.y-=joystickSpeed
                
            }
                
            else if keyCode == 1 {
                self.cursor.frame.origin.y+=joystickSpeed
                
            }
            else if keyCode == 2 {
                self.cursor.frame.origin.x-=joystickSpeed
            }
                
            else if keyCode == 3 {
                self.cursor.frame.origin.x+=joystickSpeed
                
            }
            
            
            if initialX != self.cursor.frame.origin.x || initialY != self.cursor.frame.origin.y {
                onCursorMoved()
            }
            
        }
    }
    
    func onCursorMoved(){
        
        
        var isAnyViewClickable = false
        
        
        

   
        for subview in draggableViews {
            
            if (isViewClickable(clickableView: subview) && isXPressed && !isOtherMoving(currentView: subview)){
                
                for dropView in self.dropableViews {
                        
                        if dropView.draggableView == subview {
                            dropView.removeDraggableView()
                            
                        }
                    
                }
                
                isAnyViewClickable = true
                subview.updateFrame(view: self.cursor)
                
            }
            
        }
        
        if !isAnyViewClickable {
            isXPressed = false
        }
        
    }
    
    
    func isOtherMoving(currentView:DraggableView)->Bool{
        
        for subview in draggableViews {
            
            if subview == currentView {
                continue
            }
            
            if subview.isMoving {
                return true
            }
            
        }
        return false
    }
    
    @objc func tapAction(_ sender: UILongPressGestureRecognizer) {
        
        
        if sender.state == .began {
            iskeyDown = true
        } else {
            iskeyDown = false;
            keyCode = -1
        }
        
        let point = sender.location(in: joystickKeypad)
        
        let width = joystickKeypad.bounds.width
        let height = joystickKeypad.bounds.height
        
        if(point.y < height*0.35 ){
            keyCode = 0
            
        }
        else if(point.y > height*0.7 ){
            keyCode = 1
            
            
        }
        else if(point.x > width*0.5 ){
            keyCode = 3
            
        }
            
        else if(point.x < width*0.5 ){
            keyCode = 2
            
        }
    }
    
    func isViewClickable(clickableView:UIView )->Bool{
        
        let frame = CGRect(x: ( cursor.frame.minX + cursor.frame.maxX ) / 2, y: ( cursor.frame.minY + cursor.frame.maxY ) / 2, width: 1.0, height: 1.0)
        return frame.intersects(clickableView.frame)
        
    }
    
    func onAllDropableConsumed(){
        self.iskeyDown = false
        print("All Dropable Consumed")
    }
    
}
