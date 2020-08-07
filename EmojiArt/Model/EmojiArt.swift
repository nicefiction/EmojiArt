//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 06/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import Foundation


struct EmojiArt {
    
     // /////////////////
    //  MARK: PROPERTIES
    
    var backgroundURL: URL?
    var emojis: [Emoji] = [Emoji]()
    private var uniqueEmojiID: Int = 0
    
    
    
     // //////////////////
    //  MARK: NAMESPACING
    
    struct Emoji: Identifiable {
        
        // /////////////////
        //  MARK: PROPERTIES
        
        let id: Int
        
        let text: String
        var x: Int // offset from the center
        var y: Int // offset from the center
        var size: Int
        
        
        
         // //////////////////////////
        //  MARK: INITIALIZER METHODS
        
        fileprivate init(id: Int ,
                         text: String ,
                         x: Int ,
                         y: Int ,
                         size: Int) {
            
            self.id   = id
            self.text = text
            self.x    = x
            self.y    = y
            self.size = size
        } // init() {}
    } // struct Emoji {}
    
    
    
     
    
    
    
    
     // //////////////
    //  MARK: METHODS
    
    mutating func addEmoji(_ text: String ,
                           x: Int ,
                           y: Int ,
                           size: Int) {
        
        uniqueEmojiID += 1
        emojis.append(Emoji(id : uniqueEmojiID ,
                            text : text ,
                            x : x ,
                            y : y ,
                            size : size))
        
    } // mutating func addEmoji() {}
    
    
    
    
    
} // struct EmojiArt {}
