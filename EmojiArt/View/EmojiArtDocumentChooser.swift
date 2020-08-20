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
        
        NavigationView {
            
            List {
                
                ForEach(store.documents) { document in
                    
                    NavigationLink(destination :
                        EmojiArtDocumentView(document : document)
                            .navigationBarTitle(self.store.name(for : document)) ,
                                   
                                   label : { Text(self.store.name(for : document)) })
                } // ForEach(store.documents) { document in }
            } // List {}
                .navigationBarTitle(self.store.name)
                .navigationBarItems(leading : Button(action : { self.store.addDocument() } ,
                                                     label : {
                                                        Image(systemName: "plus")
                                                            .imageScale(.large) }))
        } // NavigationView {}
        
        
        
    } // var body: some View {}
} // struct EmojiArtDocumentChooser: View {}




 // ///////////////
//  MARK: PREVIEWS

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
