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
            
            
            Rectangle()
                .foregroundColor(Color.yellow)
                .edgesIgnoringSafeArea([.horizontal , .bottom])
        } // VStack {}
        
        
        
    } // var body: some View {}
} // struct ContentView: View {}
