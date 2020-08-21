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
                .onDelete(perform : { indexSet in
                    indexSet.map {
                        self.store.documents[$0]
                    }.forEach { document in
                        self.store.removeDocument(document)
                    } // .forEach {}
                }) // .onDelete()
            } // List {}
                .navigationBarTitle(self.store.name)
                .navigationBarItems(leading :
                    Button(action : { self.store.addDocument() } ,
                           label : {
                            Image(systemName: "plus")
                                .imageScale(.large)
                    }) // Button(action: , label: )
            ) // .navigationBarItems(leading: )
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
