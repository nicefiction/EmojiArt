//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 16/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


struct PaletteEditor: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @EnvironmentObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    
    @State private var paletteName: String = ""
    @State private var emojisToAdd: String = ""
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        VStack(spacing : 0) {
            Text("Palette Editor")
                .font(.headline)
                .padding()
            
            
            Divider()
            
            
            Form {
                TextField("Palette name" ,
                          text : $paletteName ,
                          onEditingChanged : { began in
                            if !began {
                                self.document.renamePalette(self.chosenPalette ,
                                                            to : self.paletteName)
                            } // if !began {}
                }) // onEditingChanged : { began in }
                
                
                TextField("Add an emoji" ,
                          text : $emojisToAdd ,
                          onEditingChanged : { began in
                            if !began {
                                self.chosenPalette = self.document.addEmoji(self.emojisToAdd ,
                                                                            toPalette : self.chosenPalette)
                                self.emojisToAdd = ""
                            } // if !began {}
                }) // onEditingChanged : { began in }
                
                
                Section(header : Text("Remove Emoji") ,
                        content : {
                            VStack {
                                ForEach(chosenPalette.map({ String($0) }) ,
                                        id : \.self) { emoji in
                                            Text(emoji)
                                                .onTapGesture {
                                                    self.chosenPalette = self.document.removeEmoji(emoji ,
                                                                                                   fromPalette : self.chosenPalette)
                                            } // .onTapGesture {}
                                } // ForEach()
                            } // VStack {}
                }) // Section(header: , content:) {}
            } // Form {}
        } // VStack {}
        .onAppear(perform : {
            self.paletteName = self.document.paletteNames[self.chosenPalette] ?? ""
        }) // .onAppear(perform: {})
     
        
        
    } // var body: some View {}
} // struct PaletteEditor: View {}
