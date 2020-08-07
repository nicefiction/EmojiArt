//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 05/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


struct EmojiArtDocumentView: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @ObservedObject var document: EmojiArtDocument
    
    
    /* Control Panel
     */
    
    private let defaultEmojiSize: CGFloat = 40.0
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) } ,
                            id : \.self) { emoji in
                                
                                Text(emoji)
                                    .font(Font.system(size : self.defaultEmojiSize))
                                    .onDrag { return NSItemProvider(object : emoji as NSString) }
                                
                    } // ForEach() {}
                } // HStack {}
            } // ScrollView(.horizontal) {}
                .padding(.horizontal)
            
            
            GeometryReader { geometry in
                ZStack {
                    Color.white // instead of Rectangle().foregroundColor(Color.white)
                        .overlay(
                            Group {
                                if self.document.backgroundImage != nil {
                                    Image(uiImage : self.document.backgroundImage!)
                                } // if self.document.backgroundImage != nil {}
                            } // Group {}
                    ) // .overlay()
                        .edgesIgnoringSafeArea([.horizontal , .bottom])
                        .onDrop(of : ["public.image" , "public.text"] ,
                                isTargeted : nil) { providers , location in
                                    var location = geometry.convert(location , from : .global)
                                    location = CGPoint(x : location.x - geometry.size.width/2 ,
                                                       y : location.y - geometry.size.height/2)
                                    
                                    return self.drop(providers : providers ,
                                                     at : location)
                    } // .onDrop(of: , isTargeted:) {}
                    
                    
                    ForEach(self.document.emojis) { emoji in
                        Text(emoji.text)
                            .font(self.font(for : emoji))
                            .position(self.position(for : emoji ,
                                                    in : geometry.size))
                    } // ForEach(self.document.emojis) { emoji in }
                } // ZStack {}
            } // GeometryReader { geometry in }
        } // VStack {}
    } // var body: some View {}
    
    
    
     // //////////////
    //  MARK: METHODS
    
    private func drop(providers: [NSItemProvider] ,
                      at location: CGPoint)
        -> Bool {
            
            var found = providers.loadFirstObject(ofType : URL.self) { url in
                print("Dropped \(url)")
                self.document.setBackgroundURK(url)
            } // let found = providers.loadFirstObject(ofType: URL.self)}
            
            if !found {
                found = providers.loadObjects(ofType: String.self) { string in
                    self.document.addEmoji(string ,
                                           at : location ,
                                           size : self.defaultEmojiSize)
                } // found = providers.loadObjects(ofType: String.self) {}
            } // if !found {}
            
            return found
    } // private func drop(providers: [NSItemProvider]) -> Bool {}
    
    
    private func font(for emoji: EmojiArt.Emoji)
        -> Font {
            
            Font.system(size : emoji.fontSize)
    } // private func font(for emoji: EmojiArt.Emoji) -> Font {}
    
    
    private func position(for emoji: EmojiArt.Emoji ,
                          in size: CGSize)
        -> CGPoint {
            
            CGPoint(x : emoji.location.x + size.width/2 ,
                    y : emoji.location.y + size.height/2)
    } // private func position(for: : EmojiArt.Emoji , in size: CGSize) -> CGPoint {}
    
    
    
} // struct ContentView: View {}
