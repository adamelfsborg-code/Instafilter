//
//  ContentView.swift
//  Instafilter
//
//  Created by Adam Elfsborg on 2024-08-05.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        ContentUnavailableView {
            Label("No Snippets", systemImage: "swift")
        } description: {
            Text("You don't have any snippets saved yet.")
        } actions: {
            Button("Add your first snippet") { }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
}
