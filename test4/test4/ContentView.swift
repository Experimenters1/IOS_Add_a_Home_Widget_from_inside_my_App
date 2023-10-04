//
//  ContentView.swift
//  test4
//
//  Created by Huy Vu on 10/3/23.
//

import SwiftUI
import URLImage

class ImageLoader: ObservableObject {
//    @Published var imageUrlString: String = ""
    @Published var imageUrlString: String = "" {
            didSet {
                print("ImageLoader imageUrlString changed to: \(imageUrlString)")
            }
        }
    
    init() {
        let userDefaults = UserDefaults(suiteName: "group.huy.test1")
        imageUrlString = userDefaults?.value(forKey: "text") as? String ?? ""
        
        // Start a timer to check for URL changes periodically (e.g., every 5 seconds)
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            if let newImageUrlString = userDefaults?.value(forKey: "text") as? String, self.imageUrlString != newImageUrlString {
                DispatchQueue.main.async {
                    self.imageUrlString = newImageUrlString
                }
            }
        }
    }
}





struct ContentView: View {
    @ObservedObject private var imageLoader = ImageLoader()
    
    var body: some View {
        if let imageUrl = URL(string: imageLoader.imageUrlString) {
            URLImage(imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .onAppear {
                print("ContentView imageUrl: \(imageLoader.imageUrlString)")
            }
        } else {
            Text("Invalid URL")
        }

    }
}

#Preview {
    ContentView()
}

