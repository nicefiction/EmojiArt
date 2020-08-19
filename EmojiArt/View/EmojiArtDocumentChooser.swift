//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 19/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


struct EmojiArtDocumentChooser: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @EnvironmentObject var store: EmojiArtDocumentStore
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        List {
            
            ForEach(store.documents) { document in
                
                Text(self.store.name(for : document))
            } // ForEach(store.documents) { document in }
        } // List {}
        
        
        
    } // var body: some View {}
} // struct EmojiArtDocumentChooser: View {}




 // ///////////////
//  MARK: PREVIEWS

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
