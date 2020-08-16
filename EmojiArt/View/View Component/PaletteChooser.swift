//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 12/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


struct PaletteChooser: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @ObservedObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    
    @State var isShowingPaletteEditor: Bool = false
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        HStack {
            Stepper(
                onIncrement : { self.chosenPalette = self.document.palette(after : self.chosenPalette) } ,
                onDecrement : { self.chosenPalette = self.document.palette(before : self.chosenPalette) } ,
                label : { EmptyView() })
            
            Text(self.document.paletteNames[self.chosenPalette] ?? "")
            
            Image(systemName: "keyboard")
                .imageScale(.large)
                .onTapGesture {
                    self.isShowingPaletteEditor = true
            } // .onTapGesture {}
                .popover(isPresented : $isShowingPaletteEditor ,
                         content : {
                            PaletteEditor(chosenPalette : self.$chosenPalette)
                                .environmentObject(self.document)
                                .frame(minWidth : 300 ,
                                       minHeight : 500)
                }) // .popover(isPresented:) {}
        } // HStack {}
            .fixedSize(horizontal : true ,
                       vertical : false)
            .onAppear(perform : {
                self.chosenPalette = self.document.defaultPalette
            }) // .onAppear(perform: {})
        
        
        
    } // var body: some View {}
} // struct PaletteChooser: View {}



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





 // ///////////////
//  MARK: PREVIEWS

struct PaletteChooser_Previews: PreviewProvider {
    
    static var previews: some View {
        PaletteChooser(document : EmojiArtDocument() ,
                       chosenPalette : Binding.constant(""))
    } // static var previews: some View {}
} // struct PaletteChooser_Previews: PreviewProvider {}
