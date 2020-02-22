//
//  WorksheetViewController.swift

//
//  Created by FAISAL KHALID on 11/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import UIKit

class WorksheetViewController: JoystickViewController,ClickableViewListener {
    
    
    
    var sentences:[Sentence] = []
    var currentSentence:Sentence?
    var currentSentenceIndex:Int = 0
    @IBOutlet var ratingPanel:UIView?
    @IBOutlet var baeedButton:ClickableView?
    @IBOutlet var qareebButton:ClickableView?
    @IBOutlet weak var restartButton: ClickableView!
    
    
    var currentRating = 0
    
    func increaseRatingValue(){
        
        var isChanged = false
        for (i,subView) in ratingPanel!.subviews.enumerated() {
            if let subView = subView as? UIImageView {
                
                if i <= self.currentRating  {
                    
                    if !subView.isHighlighted {
                        subView.isHighlighted = true
                        isChanged = true
                    }
                    
                    
                }
            }
        }
        
        if isChanged {
            self.currentRating  = self.currentRating + 1
        }
        self.ratingPanel?.layoutIfNeeded()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        super.viewDidAppear(animated)
        
        baeedButton?.delegate = self
        qareebButton?.delegate = self
        restartButton?.delegate = self
        
        if let sentences = loadSentencesFromFile() {
            self.sentences = sentences
            
            if sentences.count > 0 {
                currentSentence = sentences[0]
                createBoxesUI(sentence: currentSentence!)
                createDashesUI(sentence: currentSentence!)
            }
            
        }
        
        
    }
    
    func onClickableViewBtnClicked(sender: ClickableView) {
        
        
        if self.restartButton == sender {
            UIView.animate(withDuration: 1.0, animations: {
                self.restartButton?.backgroundColor = .green
                
            } , completion: { completed in
                self.restartButton?.backgroundColor = .clear
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    
                    DispatchQueue.main.async {
                        self.restartButton.isHidden = true
                        
                    }
                    self.resetRatingValue()
                  
                    self.currentSentenceIndex = -1
                    self.displayNextQuestion()
                    
                }
            })
        }
        else if self.baeedButton == sender {
            
            if currentSentence?.type ==  "بعيد" {
                UIView.animate(withDuration: 1.0, animations: {
                    self.baeedButton?.backgroundColor = .green
                    
                } , completion: { completed in
                    
                    
                    
                    
                    self.baeedButton?.backgroundColor = .clear
                    
                    self.hideSentenceType()
                    self.removeCompleteSentenceUI()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                        self.increaseRatingValue()
                        
                        self.displayNextQuestion()
                        
                    }
                })
                
            } else {
                
                Sound.play(file: "wrong", fileExtension: "mp3", numberOfLoops: 0, volume: 1.0)
                
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.baeedButton?.backgroundColor = .red
                    
                } , completion: { completed in
                    
                    UIView.animate(withDuration: 2.0) {
                        self.baeedButton?.backgroundColor = .clear
                    }
                    
                    
                })
                
            }
        }
        else if self.qareebButton == sender {
            
            if currentSentence?.type == "قريب" {
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.qareebButton?.backgroundColor = .green
                    
                } , completion: { completed in
                    self.hideSentenceType()
                    self.removeCompleteSentenceUI()
                    
                    
                    self.qareebButton?.backgroundColor = .clear
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2){
                        self.increaseRatingValue()
                        
                        self.displayNextQuestion()
                        
                    }
                    
                })
                
                
            }
            else {
                
                
                Sound.play(file: "wrong", fileExtension: "mp3", numberOfLoops: 0, volume: 1.0)
                UIView.animate(withDuration: 1.0, animations: {
                    self.qareebButton?.backgroundColor = .red
                    
                } , completion: { completed in
                    
                    UIView.animate(withDuration: 2.0) {
                        self.qareebButton?.backgroundColor = .clear
                    }
                    
                    
                })
                
                
                
                
            }
        }
        
    }
    func resetRatingValue(){
        currentRating = 0
        for subview in self.ratingPanel!.subviews {
            if let subview = subview as? UIImageView {
                subview.isHighlighted = false
            }
        }
        self.ratingPanel?.layoutIfNeeded()
    }
    
    
    func displayNextQuestion(){
        
        if currentSentenceIndex + 1 < self.sentences.count {
            currentSentenceIndex = currentSentenceIndex + 1
            currentSentence = self.sentences[currentSentenceIndex]
            createBoxesUI(sentence: currentSentence!)
            createDashesUI(sentence: currentSentence!)
        }
        else {
            
            // all questions finished
            
            self.restartButton.isHidden = false
            
            
        }
        
    }
    
    
    
    func removeCompleteSentenceUI(){
        self.view.viewWithTag(50)?.removeFromSuperview()
        self.view.viewWithTag(51)?.removeFromSuperview()
        self.view.layoutIfNeeded()
    }
    func createCompleteSentenceUI(sentence:Sentence){
        
        let sentenceLabel = UILabel()
        sentenceLabel.text = sentence.sentence
        sentenceLabel.textColor = UIColor(red: 254.0, green: 218.0, blue: 0.0, alpha: 1.0)
        sentenceLabel.font = sentenceLabel.font.withSize(30.0)
        sentenceLabel.sizeToFit()
        
        sentenceLabel.alpha = 0.0
        sentenceLabel.center = self.view.center
        
        
        
        let lineImageview = UIImageView(image: UIImage(named: "line"))
        let frame = sentenceLabel.frame
        lineImageview.frame = CGRect(x: frame.minX, y: frame.maxY , width: frame.width, height: 1.0)
        lineImageview.alpha = 0.0
        
        
        self.view.addSubview(lineImageview)
        self.view.addSubview(sentenceLabel)
        
        self.view.layoutIfNeeded()
        sentenceLabel.tag = 50
        lineImageview.tag = 51
        
        sentenceLabel.fadeIn()
        lineImageview.fadeIn()
    }
    
    func createBoxesUI(sentence:Sentence){
        
        
        let shuffledWords = sentence.words.shuffled()
        let boxSize =  Size.boxSize(noOfWords: shuffledWords.count)
        
        var posX = boxSize.paddingLeft
        for word in shuffledWords {
            let rect = CGRect(x: posX, y: 200, width: boxSize.content, height: boxSize.size*0.3)
            posX = posX + boxSize.size
            let dragView = DraggableView()
            
            dragView.commonInit(frame: rect,word: word)
            self.view.addSubview(dragView)
            
        }
        
        
        
    }
    func showSentenceType(){
        
        
        UIView.animate(withDuration: 2.0){
            self.baeedButton?.alpha  = 1.0
            self.qareebButton?.alpha = 1.0
        }
        self.baeedButton?.isHidden = false
        self.qareebButton?.isHidden = false
        
    }
    
    func hideSentenceType(){
        
        
        UIView.animate(withDuration: 2.0){
            self.baeedButton?.alpha  = 0.0
            self.qareebButton?.alpha = 0.0
        }
        
        self.baeedButton?.isHidden = true
        self.qareebButton?.isHidden = true
        
        
    }
    func createDashesUI(sentence:Sentence){
        
        //arabic content is right to left so reversed the list
        let words = sentence.words.reversed()
        let boxSize =  Size.boxSize(noOfWords: words.count)
        var posX = boxSize.paddingLeft
        
        
        for word in words {
            let rect2 = CGRect(x: posX, y: 350, width: boxSize.content, height: boxSize.size * 0.5)
            posX = posX + boxSize.size
            
            let dropView = DropableView()
            dropView.commonInit(frame: rect2,word: word)
            
            self.view.addSubview(dropView)
            
        }
        
        
    }
    
    override func onAllDropableConsumed() {
        // check for correct sentence
        
        var isCorrectSentence = true
        for dropView in self.dropableViews {
            if !dropView.isValidBox(){
                isCorrectSentence = false
            }
        }
        
        if (isCorrectSentence) {
            createCompleteSentenceUI(sentence:currentSentence!)
            removeAllBoxesAndLinesUI()
            showSentenceType()
            
        }
        else {
            
            
            
            for draggableView in self.draggableViews {
                UIView.animate(withDuration: 1.0, animations: {
                    draggableView.center = draggableView.initialCenterPoint!
                    
                    draggableView.backgroundColor = .red
                }){ animated in
                    
                    UIView.animate(withDuration: 1.0){
                        draggableView.backgroundColor = .clear
                        
                    }
                    
                    
                }
            }
            
            for dropableView in self.dropableViews {
                dropableView.removeDraggableView()
            }
            
        }
    }
    
    
    func removeAllBoxesAndLinesUI(){
        
        for subView in self.view.subviews {
            if let subView = subView as? DraggableView {
                UIView.animate(withDuration: 1.0){
                    subView.alpha = 0.0
                }
            }
            if let subView = subView as? DropableView {
                UIView.animate(withDuration: 1.0){
                    subView.alpha = 0.0
                }
            }
            
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0){
            
            for subview in self.draggableViews {
                subview.removeFromSuperview()
            }
            
            
            
            for subview in self.dropableViews {
                subview.removeFromSuperview()
            }
            
            self.draggableViews = []
            self.dropableViews = []
        }
        
    }
    
    
    func loadSentencesFromFile()->[Sentence]? {
        do {
            let path = Bundle.main.path(forResource: "Content", ofType: "plist")!
            let urlPath = URL(fileURLWithPath: path)
            let plistDecoder = PropertyListDecoder()
            let data = try Data.init(contentsOf: urlPath)
            let setences = try plistDecoder.decode([Sentence].self, from: data)
            return setences
        }
        catch {
            return nil
        }
        
    }
    
}
