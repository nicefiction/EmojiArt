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
                .sheet(isPresented : $isShowingPaletteEditor ,
                       content : {
                        PaletteEditor(chosenPalette : self.$chosenPalette ,
                                      isShowingPaletteEditor : self.$isShowingPaletteEditor )
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





 // ///////////////
//  MARK: PREVIEWS

struct PaletteChooser_Previews: PreviewProvider {
    
    static var previews: some View {
        PaletteChooser(document : EmojiArtDocument() ,
                       chosenPalette : Binding.constant(""))
    } // static var previews: some View {}
} // struct PaletteChooser_Previews: PreviewProvider {}
