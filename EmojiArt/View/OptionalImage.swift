//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 10/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


struct OptionalImage: View {
    
     // /////////////////
    //  MARK: PROPERTIES
    
    var uiImage: UIImage?
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        Group {
            if uiImage != nil {
                Image(uiImage : uiImage!)
            } // if self.document.backgroundImage != nil {}
        } // Group {}
        
        
        
    } // var body: some View {}
} // struct OptionalImage: View {}
