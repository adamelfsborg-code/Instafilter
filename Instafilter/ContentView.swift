//
//  ContentView.swift
//  Instafilter
//
//  Created by Adam Elfsborg on 2024-08-05.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import SwiftUI
import StoreKit

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    
    @State private var processedImage: Image?
    @State private var selectedImage: PhotosPickerItem?
    
    @State private var showingFilters = false
    
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 100.0
    @State private var filterScale = 5.0
    
    
    @AppStorage("Filtercount") var filterCount = 0
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedImage) {
                    if let processedImage {
                        processedImage.resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("Tap to add picture"))
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedImage, loadImage)
                
                Spacer()
                
                VStack {
                    HStack {
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                            .onChange(of: filterIntensity, applyProcessing)
                    }
                    HStack {
                        Text("Radius")
                        Slider(value: $filterRadius, in: 0...200)
                            .onChange(of: filterRadius, applyProcessing)
                            
                    }
                    HStack {
                        Text("Scale")
                        Slider(value: $filterScale, in: 0...20)
                            .onChange(of: filterScale, applyProcessing)
                    }
                }
                .disabled(selectedImage == nil)
                
                HStack {
                    Button("Change filter", action: changeFilter)
                        .disabled(selectedImage == nil)
                    
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("Instafilter", image: processedImage))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystallize") {setFilter(CIFilter.crystallize()) }
                Button("Edges") {setFilter(CIFilter.edges()) }
                Button("Gaussian Blue") {setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") {setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") {setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") {setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") {setFilter(CIFilter.vignette()) }
                Button("Posterize") {setFilter(CIFilter.colorPosterize()) }
                Button("Disc Blur") {setFilter(CIFilter.discBlur()) }
                Button("Fade Effect") {setFilter(CIFilter.photoEffectFade()) }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale, forKey: kCIInputScaleKey)
        }
    
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        
        if filterCount >= 20 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
