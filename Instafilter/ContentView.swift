//
//  ContentView.swift
//  Instafilter
//
//  Created by Adam Elfsborg on 2024-08-05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let tuscany = Image(.tuscany)
        VStack {
            ShareLink(item: URL(string: "https://hackingwithswift.com")!, subject: Text("Learn Swift"), message: Text("Check out the 100 days of Swift challenge")) {
                Label("Spread the word", systemImage: "swift")
                
                
                ShareLink(item: tuscany, preview: SharePreview("Tuscany wallpaper", image: tuscany))
            }
        }
    }
}

#Preview {
    ContentView()
}
