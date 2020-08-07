//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 05/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


class EmojiArtDocument: ObservableObject {
    
     // /////////////////////////
    //  MARK: PROPERTY OBSERVERS
    
    @Published private var emojiArt: EmojiArt = EmojiArt()

    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    static let palette: String = "🤞👻🌋🌞💞💦📚"
    
    
    
     // //////////////
    //  MARK: METHODS
    
    /* Intents :
     */
    
    func addEmoji(_ emoji: String ,
                  at location: CGPoint ,
                  size: CGFloat) {
        
        emojiArt.addEmoji(emoji ,
                          x : Int(location.x) ,
                          y : Int(location.y) ,
                          size : Int(size))
    } // func addEmoji() {}
    
    
    func moveEmoji(_ emoji: EmojiArt.Emoji ,
                   by offset: CGSize) {
        
        if
            let index = emojiArt.emojis.firstIndex(matching : emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        } // if let {}
    } // func moveEmoji() {}
    
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji ,
                    by scale: CGFloat) {
        
        if let index = emojiArt.emojis.firstIndex(matching : emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        } // if let {}
    } // func scaleEmoji() {}
    
    
    func setBackgroundURK(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
    } // func setBackgroundURK(_ url: URL?) {}
    
    
    
    
    
} // class EmojiArtDocument: ObservableObject {}
