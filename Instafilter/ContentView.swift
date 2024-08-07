//
//  ContentView.swift
//  Instafilter
//
//  Created by Adam Elfsborg on 2024-08-05.
//
import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var pickerItems = [PhotosPickerItem]()
    @State private var selectedImages = [Image]()
    var body: some View {
        VStack {
            PhotosPicker(selection: $pickerItems, maxSelectionCount: 5, matching: .any(of: [.images, .not(.screenshots)])) {
                Label("Select a picture", systemImage: "photo")
            }
            
            ScrollView {
                ForEach(0..<selectedImages.count, id: \.self) { i in
                    selectedImages[i].resizable().scaledToFit()
                }
            }
        }
        .onChange(of: pickerItems) {
            Task {
                selectedImages.removeAll()
                for item in pickerItems {
                    if let loadedImage =  try await item.loadTransferable(type: Image.self) {
                        selectedImages.insert(loadedImage, at: 0)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
