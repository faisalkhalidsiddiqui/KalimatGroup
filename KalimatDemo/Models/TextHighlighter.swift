//
//  TextHighlighter.swift
//  KalimatDemo
//
//  Created by FAISAL KHALID on 22/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import Foundation
import UIKit

class TextHighlighter {
    private let text:UILabel
    private let wordsTime:[WordTime]
    private  let audioFileName:String
    private let audioFileExtension:String
    private var counter = 0
    
    init(text:UILabel,audioFileName:String,audioFileExtension:String, seqFileName:String){
        self.text = text
        let sentenceJson =  TextHighlighter.readjson(fileName: seqFileName)
        self.wordsTime = try! JSONDecoder().decode([WordTime].self, from: sentenceJson as Data)
        self.audioFileName = audioFileName
        self.audioFileExtension = audioFileExtension
    }
    
    
    static func readjson(fileName: String) -> NSData{
        
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = NSData(contentsOfFile:  path!)
        return jsonData!
    }
    
    
    
    func start(){
        
        
        Sound.play(file: audioFileName, fileExtension: audioFileExtension, numberOfLoops: 0,volume: 1.0)
        var counter = 0
        
        for wordTime in wordsTime {
            
            
            let wordCount =  wordTime.word.unicodeScalars.count
            
            
            let time = (wordTime.endTime - wordTime.startTime) / Double(wordCount)
            
            for i in 1...wordCount {
                let val = counter + i
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + wordTime.startTime + time){
                    self.textHighlighter(from: 0, to: val)
                    
                }
            }
            
            
            
            counter = counter + wordCount + 1
          
            
        }
        
        
        
    }
    
    
    
    @objc private func textHighlighter(from:Int,to:Int){
        
        if counter < text.text!.unicodeScalars.count  {
            let s = text.text! as NSString
            let att = NSMutableAttributedString(string: s as String)
            
            
            att.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(from...to))
            
            DispatchQueue.main.async {
                self.text.attributedText = att
                
            }
        }
        counter = counter + 1
        
        
    }
    
    
    
}
