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
                                
                    } // ForEach() {}
                } // HStack {}
            } // ScrollView(.horizontal) {}
                .padding(.horizontal)
            
            
            Color.white // instead of Rectangle().foregroundColor(Color.white)
                .overlay(
                    Group {
                        if self.document.backgroundImage != nil {
                            Image(uiImage : self.document.backgroundImage!)
                        } // if self.document.backgroundImage != nil {}
                    } // Group {}
            ) // .overlay()
                .edgesIgnoringSafeArea([.horizontal , .bottom])
                .onDrop(of : ["public.image"] ,
                        isTargeted : nil) { providers , location in
                            return self.drop(providers : providers)
            } // .onDrop(of: , isTargeted:) {}
        } // VStack {}
    } // var body: some View {}
    
    
    
     // //////////////
    //  MARK: METHODS
    
    private func drop(providers: [NSItemProvider])
        -> Bool {
            
            let found = providers.loadFirstObject(ofType : URL.self) { url in
                print("Dropped \(url)")
                self.document.setBackgroundURK(url)
            } // let found = providers.loadFirstObject(ofType: URL.self)}
            
            return found
    } // private func drop(providers: [NSItemProvider]) -> Bool {}
    
    
    
    
    
    
} // struct ContentView: View {}
