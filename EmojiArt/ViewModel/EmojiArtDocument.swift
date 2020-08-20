//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 05/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI
import Combine


class EmojiArtDocument: ObservableObject ,
                        Hashable ,
                        Identifiable {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @Published private var emojiArt: EmojiArt
    @Published private(set) var backgroundImage: UIImage?
    @Published var steadyStateZoomScale: CGFloat = 1.0
    @Published var steadyStatePanOffset: CGSize =  .zero

    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    static let palette: String = "🤞👻🌋🌞💞💦📚"
    private var autoSaveCancellable: AnyCancellable?
    private var fetchImageCancellable: AnyCancellable?
    let id: UUID
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var emojis: [EmojiArt.Emoji] {
        return emojiArt.emojis
    } // var emojis: [EmojiArt.Emoji] {}
    
    
    
     // //////////////////////////
    //  MARK: INITIALIZER METHODS
    
    init(id: UUID? = nil) {
        
        self.id = id ?? UUID()
        let defaultsKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey : defaultsKey)) ?? EmojiArt()
        
        autoSaveCancellable = $emojiArt.sink(receiveValue : { emojiArt in
            print("json = \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json ,
                                      forKey : defaultsKey)
        })
        fetchBackgroundImageData()
    } // init() {}
    
    
    
     // /////////////////////////
    //  MARK: PROPERTY OBSERVERS
    
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
            // BAD CODE :
//            DispatchQueue.global(qos : .userInitiated).async {
//                if
//                    let imageData = try? Data(contentsOf : url) {
//                    DispatchQueue.main.async {
//                        if url == self.emojiArt.backgroundURL {
//                            self.backgroundImage = UIImage(data : imageData)
//                        } // if url == self.emojiArt.backgroundURL {}
//                    } // DispatchQueue.main.async {}
//                } // if let imageData {}
//            } // DispatchQueue.global(qos : .userInitiated).async {}
            
            fetchImageCancellable?.cancel() // Cancel the previous request if there is any .
            
            // URLSESSION CODE :
//            let session = URLSession.shared
//
//            let publisher = session.dataTaskPublisher(for : url)
//                .map { data , urlResponse in
//                    UIImage(data : data)
//            } // .map { data , urlResponse in }
//                .receive(on : DispatchQueue.main)
//                .replaceError(with : nil)
//
//            fetchImageCancellable = publisher.assign(to : \EmojiArtDocument.backgroundImage ,
//                                                     on : self)
            // REFACTORED CODE :
            fetchImageCancellable = URLSession.shared.dataTaskPublisher(for : url)
                .map { data , urlResponse in
                    UIImage(data : data)
            } // .map { data , urlResponse in }
                .receive(on : DispatchQueue.main)
                .replaceError(with : nil)
                .assign(to : \EmojiArtDocument.backgroundImage ,
                        on : self)
        } // if let url {}
    } // private func fetchBackgroundImageData() {}
    
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
    }
    
    
    static func == (lhs: EmojiArtDocument ,
                    rhs: EmojiArtDocument)
        -> Bool {
            
            lhs.id == rhs.id
    }





} // class EmojiArtDocument: ObservableObject {}





 // /////////////////
//  MARK: EXTENSIONS

extension EmojiArt.Emoji {
    
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x : CGFloat(x) ,
                                    y : CGFloat(y)) }
    
} // extension EmojiArt.Emoji {}
