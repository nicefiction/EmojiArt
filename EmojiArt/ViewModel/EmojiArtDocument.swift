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
    
    @Published private var emojiArt: EmojiArt {
        didSet {
            print("json = \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json ,
                                      forKey : EmojiArtDocument.untitled)
        } // didSet {}
    } // @Published private var emojiArt: EmojiArt = EmojiArt() {}
    
    @Published private(set) var backgroundImage: UIImage?

    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    static let palette: String = "🤞👻🌋🌞💞💦📚"
    private static let untitled: String = "EmojiArtDocument.Untitled"
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var emojis: [EmojiArt.Emoji] {
        return emojiArt.emojis
    } // var emojis: [EmojiArt.Emoji] {}
    
    
    
     // //////////////////////////
    //  MARK: INITIALIZER METHODS
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey : EmojiArtDocument.untitled)) ?? EmojiArt()
        fetchBackgroundImageData()   
    } // init() {}
    
    
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        } // get {}
        
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        } // set {}
    } // func setBackgroundURK(_ url: URL?) {}
    
    
    
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
    
    
    
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        
        if
            let url = self.emojiArt.backgroundURL {
            DispatchQueue.global(qos : .userInitiated).async {
                if
                    let imageData = try? Data(contentsOf : url) {
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data : imageData)
                        } // if url == self.emojiArt.backgroundURL {}
                    } // DispatchQueue.main.async {}
                } // if let imageData {}
            } // DispatchQueue.global(qos : .userInitiated).async {}
        } // if let url {}
    } // private func fetchBackgroundImageData() {}
    
    
    
    
    
} // class EmojiArtDocument: ObservableObject {}





 // /////////////////
//  MARK: EXTENSIONS

extension EmojiArt.Emoji {
    
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x : CGFloat(x) ,
                                    y : CGFloat(y)) }
    
} // extension EmojiArt.Emoji {}
