//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 12/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


struct PaletteChooser: View {
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        HStack {
            Stepper(onIncrement : {} ,
                    onDecrement : {} ,
                    label : {
                        EmptyView()
            })
            
            Text("Palette name")
        } // HStack {}
            .fixedSize(horizontal : true ,
                       vertical : false)
        
        
        
    } // var body: some View {}
} // struct PaletteChooser: View {}




 // ///////////////
//  MARK: PREVIEWS

struct PaletteChooser_Previews: PreviewProvider {
    
    static var previews: some View {
        PaletteChooser()
    } // static var previews: some View {}
} // struct PaletteChooser_Previews: PreviewProvider {}
