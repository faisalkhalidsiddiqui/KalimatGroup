//
//  Sentence.swift
//  katibaJoystic
//
//  Created by FAISAL KHALID on 14/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import Foundation

struct Sentence:Codable {
    var type:String
    var sentence:String

    var words:[String] {
        
        var word = ""
        var words:[String] = []
        for (id,letter) in self.sentence.enumerated() {
      
                if letter.isPunctuation {
                    
                    if !word.isEmpty {
                    words.append(word)
                        word = ""
                    }
                    words.append(String(letter))
                  
                    
                }
                else if letter.isWhitespace {
                    if !word.isEmpty {
                    words.append(word)
                        word = ""
                    }
                    
                }
    
                else {
                    
                    
                    word = "\(word)\(letter)"
                    
                    if id ==  sentence.count - 1 {
                        words.append(word)
                                        word = ""
                    }
                }
            }
        return words
        
    }
    
    
}


