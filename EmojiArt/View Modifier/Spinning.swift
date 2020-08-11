//
//  Spinning.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 11/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


struct Spinning: ViewModifier {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @State var isVisible: Bool = false
    
    
    
     // //////////////
    //  MARK: METHODS
    
    func body(content: Content)
        -> some View {
            
            content
                .rotationEffect(Angle(degrees : isVisible ? 350.0 : 0.0))
                .animation(
                    Animation
                        .linear(duration : 1.00)
                        .repeatForever(autoreverses : false))
                .onAppear(perform : {
                    self.isVisible =  true
                })
        
    } // func spinnng(content: Content) -> some View {}
    
    
    
} // struct Spinning {}




 // /////////////////
//  MARK: EXTENSIONS

extension View {
    
    func spinning()
        -> some View {
            
        self.modifier(Spinning())
            
    } // func spinning() -> some View {}
} // extension View {}
