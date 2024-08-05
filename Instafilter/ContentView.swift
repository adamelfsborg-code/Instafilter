//
//  ContentView.swift
//  Instafilter
//
//  Created by Adam Elfsborg on 2024-08-05.
//

import SwiftUI

struct ContentView: View {
    @State private var blurAmount = 0.0     
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .blur(radius: blurAmount)
            
            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { oldValue, newValue in
                    print("changed from \(oldValue) to \(newValue)")
                }
            
            Button("Random blue") {
                blurAmount = Double.random(in: 0...20)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
