//
//  Pixel_Desktop_PicturesApp.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI
import SwiftData

@main
struct Pixel_Desktop_PicturesApp: App {
    
    @State private var networkManager: NetworkManager = .init()
    
    var body: some Scene {
        WindowGroup {
            TabsView()
                .windowResizeBehavior(.disabled)
                .windowMinimizeBehavior(.disabled)
                .windowFullScreenBehavior(.disabled)
                .windowDismissBehavior(.disabled)
                .environment(networkManager)
                .onFirstTaskViewModifier {
                    let imageDownloadManager: ImageDownloadManager = .init()
                    do {
                        let _ = try await imageDownloadManager.downloadImage(url: "https://unsplash.com/photos/WrawS5541bo/download?ixid=M3w2ODg0NDh8MHwxfHJhbmRvbXx8fHx8fHx8fDE3MzU4MzQwNjR8", to: .downloadsDirectory)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        }
        .getModelContainersViewModifier(
            in: .mock,
            for: [
                ImageQueryURLModel.self,
                RecentImageURLModel.self
            ]
        )
        .windowResizability(.contentSize)
        //        .windowStyle(.hiddenTitleBar)
    }
}
