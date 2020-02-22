//
//  ScreenSize.swift
//  katibaJoystic
//
//  Created by FAISAL KHALID on 14/02/2020.
//  Copyright © 2020 Faisal Khalid. All rights reserved.
//

import Foundation
import UIKit
struct Size {
    static let screenWidth:Double = Double(UIScreen.main.bounds.width)
    static let contentSize:Double =  screenWidth * 0.9
    
    
    struct boxSize {
        var paddingLeft:Double = Size.screenWidth * 0.05
        var paddingRight:Double = Size.screenWidth * 0.05
        var size:Double
        init(noOfWords:Int) {
            size = Size.contentSize / Double(noOfWords)
            
            if ( size / Size.screenWidth ) > 0.2 {
                size = Size.screenWidth * 0.2
                let paddingPerc =  ( 1 - ( Double(noOfWords) * 0.2 ) ) / 2.0
                self.paddingRight = Size.screenWidth  * paddingPerc
                self.paddingLeft =   Size.screenWidth  * paddingPerc
            }
            
        }
        var spacing:Double {
            return size*0.1
        }
        var content:Double {
            return size*0.9
        }
        
    }
}
