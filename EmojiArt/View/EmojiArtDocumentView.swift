//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Olivier Van hamme on 05/08/2020.
//  Copyright © 2020 nicefiction. All rights reserved.
//

import SwiftUI


struct EmojiArtDocumentView: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @ObservedObject var document: EmojiArtDocument
    
//    @State private var steadyStateZoomScale: CGFloat = 1.0
//    @State private var steadyStatePanOffset: CGSize =  .zero
    @State private var chosenPalette: String = ""
    
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    
    /* Control Panel
     */
    
    private let defaultEmojiSize: CGFloat = 40.0
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    private var zoomScale: CGFloat {
        document.steadyStateZoomScale * gestureZoomScale
    } // private var zoomScale: CGFloat {}
    
    
    private var panOffset: CGSize {
        (document.steadyStatePanOffset + gesturePanOffset) * zoomScale
    } // private var panOffset: CGSize {}
    
    
    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    } // var isLoading: Bool {}
    
    
    var body: some View {
        
        VStack {
            HStack {
                PaletteChooser(document : document ,
                               chosenPalette : $chosenPalette)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(chosenPalette.map { String($0) } ,
                                id : \.self) { emoji in
                                    
                                    Text(emoji)
                                        .font(Font.system(size : self.defaultEmojiSize))
                                        .onDrag { return NSItemProvider(object : emoji as NSString) }
                                    
                        } // ForEach() {}
                    } // HStack {}
                } // ScrollView(.horizontal) {}
            } // HStack {}
            
            
            GeometryReader { geometry in
                ZStack {
                    Color
                        .white // instead of Rectangle().foregroundColor(Color.white)
                        .overlay(
                            OptionalImage(uiImage : self.document.backgroundImage)
                                .scaleEffect(self.zoomScale)
                                .offset(self.panOffset)
                    ) // .overlay()
                        .gesture(self.doubleTapToZoom(in : geometry.size))
                    
                    if self.isLoading {
                        Image(systemName : "hourglass")
                            .imageScale(.large)
                            .spinning()
                    } else {
                        ForEach(self.document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize : emoji.fontSize * self.zoomScale)
                                .position(self.position(for : emoji ,
                                                        in : geometry.size))
                        } // ForEach(self.document.emojis) { emoji in }
                    } // if !self.isloading {}
                } // ZStack {}
                    .clipped()
                    .gesture(self.panGesture())
                    .gesture(self.zoomGesture())
                    .edgesIgnoringSafeArea([.horizontal , .bottom])
                    .onReceive(self.document.$backgroundImage ,
                               perform : { image in
                                self.zoomToFit(image ,
                                               in : geometry.size)
                    })
                    .onDrop(of : ["public.image" , "public.text"] ,
                            isTargeted : nil) { providers , location in
                                var location = geometry.convert(location , from : .global)
                                location = CGPoint(x : location.x - geometry.size.width/2 ,
                                                   y : location.y - geometry.size.height/2)
                                location = CGPoint(x : location.x - self.panOffset.width ,
                                                   y : location.y - self.panOffset.height)
                                location = CGPoint(x : location.x / self.zoomScale ,
                                                   y : location.y / self.zoomScale)
                                
                                return self.drop(providers : providers ,
                                                 at : location)
                } // .onDrop(of: , isTargeted:) {}
                    
                    .navigationBarItems(trailing :
                        Button(action : {
                            if
                                let url = UIPasteboard.general.url {
                                self.document.backgroundURL = url
                            }
                        } ,
                               label : {
                                Image(systemName: "doc.on.clipboard")
                                    .imageScale(.large)
                        }
                    ) // Button()
                ) // .navigationBarItems()
            } // GeometryReader { geometry in }
        } // VStack {}
    } // var body: some View {}
    
    
    
     // /////////////////////////
    //  MARK: INITIALSER METHODS
    
    init(document: EmojiArtDocument) {
        self.document = document
        _chosenPalette = State(wrappedValue : self.document.defaultPalette)
    } // init() {}
    
    
    
     // //////////////
    //  MARK: METHODS
    
    private func drop(providers: [NSItemProvider] ,
                      at location: CGPoint)
        -> Bool {
            
            var found = providers.loadFirstObject(ofType : URL.self) { url in
                print("Dropped \(url)")
                self.document.backgroundURL = url
            } // let found = providers.loadFirstObject(ofType: URL.self)}
            
            if !found {
                found = providers.loadObjects(ofType: String.self) { string in
                    self.document.addEmoji(string ,
                                           at : location ,
                                           size : self.defaultEmojiSize)
                } // found = providers.loadObjects(ofType: String.self) {}
            } // if !found {}
            
            return found
    } // private func drop(providers: [NSItemProvider]) -> Bool {}
    
    
    private func position(for emoji: EmojiArt.Emoji ,
                          in size: CGSize)
        -> CGPoint {
            
            var location = emoji.location
            location = CGPoint(x : location.x * zoomScale ,
                               y : location.y * zoomScale)
            location = CGPoint(x : location.x + size.width/2 ,
                               y : location.y + size.height/2)
            location = CGPoint(x : location.x + panOffset.width ,
                               y : location.y + panOffset.height)
            
            return location
    } // private func position(for: : EmojiArt.Emoji , in size: CGSize) -> CGPoint {}
    
    
    private func zoomToFit(_ image: UIImage? ,
                           in size: CGSize) {
        
        if
            let image = image ,
            image.size.width > 0 ,
            image.size.height > 0 ,
            size.height > 0 ,
            size.width > 0 {
            
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            self.document.steadyStatePanOffset = CGSize.zero
            self.document.steadyStateZoomScale = min(hZoom , vZoom)
            
        } // if let {}
    } // private func zoomToFit(_: UIImage ,in: CGSize) {}
    
    
    private func doubleTapToZoom(in size: CGSize)
        -> some Gesture {
            
            TapGesture(count : 2)
                .onEnded {
                    withAnimation {
                        self.zoomToFit(self.document.backgroundImage ,
                                       in : size)
                    } // withAnimation {}
            } // .onEnded {}
    } // private func doubleTapToZoom(in size: CGSize) -> some Gesture {}
    
    
    private func zoomGesture()
        -> some Gesture {
        
            MagnificationGesture()
                .updating($gestureZoomScale) { latestGestureScale , ourGestureStateInOut , transaction in
                    ourGestureStateInOut = latestGestureScale
            } // .updating($gestureZoomScale) {}
                .onEnded { finalGestureScale in
                    self.document.steadyStateZoomScale *= finalGestureScale
            } // .onEnded {}
    } // private func zoomGesture() -> some Gesture {}
    
    
    private func panGesture()
        -> some Gesture {
            
            DragGesture()
                .updating($gesturePanOffset) { latestDragGestureValue , gesturePanOffset , transaction in
                    gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
            } // .updating($gesturePanOffset) {}
                .onEnded { finalDragGestureValue in
                    self.document.steadyStatePanOffset = self.document.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
            } // .onEnded { finalDragGestureValue in }
    } // private func panGesture() -> some Gesture {}
    
    
    
} // struct ContentView: View {}
