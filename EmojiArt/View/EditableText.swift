//
//  EditableText.swift
//  EmojiArt
//
//  Created by CS193p Instructor on 5/6/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct EditableText: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @State private var editableText: String = ""

    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    var text: String = ""
    var isEditing: Bool
    var onChanged: (String) -> Void

    
    
     // //////////////////////////
    //  MARK: INITIALIZER METHODS
    
    init(_ text: String ,
         isEditing: Bool ,
         onChanged: @escaping (String) -> Void) {
        
        self.text      = text
        self.isEditing = isEditing
        self.onChanged = onChanged
        
    } // init() {}
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            TextField(text ,
                      text : $editableText ,
                      onEditingChanged : { began in
                self.callOnChangedIfChanged()
            })
                .opacity(isEditing ? 1 : 0)
                .disabled(!isEditing)
            
            
            if !isEditing {
                Text(text)
                    .opacity(isEditing ? 0 : 1)
                    .onAppear {
                        // any time we move from editable to non-editable
                        // we want to report any changes that happened to the text
                        // while were editable
                        // (i.e. we never "abandon" changes)
                        self.callOnChangedIfChanged()
                }
            }
        }
        .onAppear { self.editableText = self.text }
    }
    
    
    
     // //////////////
    //  MARK: METHODS
    
    func callOnChangedIfChanged() {
        if editableText != text {
            onChanged(editableText)
        }
    }
    
    
    
    
} // struct EditableText: View {}
