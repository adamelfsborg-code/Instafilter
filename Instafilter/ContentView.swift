//
//  ContentView.swift
//  Instafilter
//
//  Created by Adam Elfsborg on 2024-08-05.
//

import SwiftUI

struct ContentView: View {
    @State private var showingConformation = false
    @State private var backgroundColor = Color.white
    @State private var blurAmount = 0.0
    var body: some View {
        VStack {
            Button("Show") {
                showingConformation.toggle()
            }
            Slider(value: $blurAmount, in: 0...20)
                .onChange(of: blurAmount) { oldValue, newValue in
                    print("BlurAmount changed from \(oldValue) to \(newValue)")
                }
        }
        .padding()
        VStack {}
        .frame(width: 300, height: 300)
        .background(backgroundColor)
        .blur(radius: blurAmount)
        .confirmationDialog("Change background", isPresented: $showingConformation) {
            Button("Red") { backgroundColor = .red }
            Button("Blue") { backgroundColor = .blue }
            Button("Yellow") { backgroundColor = .yellow }
            Button("Green") { backgroundColor = .green }
            Button("Cancel", role: .cancel ) { }
        } message: {
            Text("Select a new background color.")
        }
    }
}

#Preview {
    ContentView()
}
