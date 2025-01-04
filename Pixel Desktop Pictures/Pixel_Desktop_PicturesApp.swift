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
    var body: some Scene {
        WindowGroup {
            SwiftUIView2()
                .windowResizeBehavior(.disabled)
                .windowMinimizeBehavior(.disabled)
                .windowFullScreenBehavior(.disabled)
                .windowDismissBehavior(.disabled)
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
