//
//  Grid.swift
//  Memorize
//
//  Created by Olivier Van hamme on 28/07/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


struct Grid<Item , ItemView , ID>: View
    where ItemView: View ,
          ID: Hashable {
    
     // /////////////////
    //  MARK: PROPERTIES
    
    private var items: Array<Item>
    private var id: KeyPath<Item , ID>
    private var viewForItem: (Item) -> ItemView
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        GeometryReader { geometryProxy in
            
            self.body(for : GridLayout(itemCount : self.items.count ,
                                       in : geometryProxy.size))
            
        } // GeometryReader { geometryProxy in }
    } // var body: some View {}
    
    
    
     // //////////////////////////
    //  MARK: INITIALIZER METHODS
    
    init(_ items: [Item] ,
         id: KeyPath<Item , ID> ,
         viewForItem: @escaping (Item) -> ItemView) {
        
        self.items       = items
        self.id          = id
        self.viewForItem = viewForItem
        
    } // init() {}
    
    
    
     // //////////////
    //  MARK: METHODS
    
    private func body(for layout: GridLayout)
        -> some View {
            
            return ForEach(items ,
                           id : id) { item in
                            
                self.body(for : item ,
                          in : layout)
            } // ForEach(items) { item in }
    } // func body(for items: [Item]) -> some View {}
    
    
    private func body(for item: Item ,
                      in layout: GridLayout)
        -> some View {
            
            let index = items.firstIndex(where : { item[keyPath : id] == $0[keyPath: id] } )
            
            return Group {
                if index != nil {
                    viewForItem(item)
                        .frame(width : layout.itemSize.width ,
                               height : layout.itemSize.height)
                        .position(layout.location(ofItemAt : index!))
                } // if index != nil {}
            } // return Group {}
    } // func body(for items: [Item]) -> some View {}
    
     
} // struct Grid: View {}





 // /////////////////
//  MARK: EXTENSIONS

extension Grid where Item: Identifiable ,
                     ID == Item.ID {
    
    init(_ items: [Item] ,
         viewForItem: @escaping (Item) -> ItemView) {
        
        self.init(items ,
                  id : \Item.id ,
                  viewForItem : viewForItem)
 
    } // init() {}
    
} // extension Grid {}
