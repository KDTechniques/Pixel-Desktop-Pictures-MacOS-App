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
    // MARK: - PROPERTIES
    private let appEnvironment: AppEnvironmentModel = .mock // Change to `.production` as needed
    @State private var networkManager: NetworkManager = .init()
   
    // MARK: - BODY
    var body: some Scene {
        WindowGroup {
            TabsView()
                .windowResizeBehavior(.disabled)
                .windowMinimizeBehavior(.disabled)
                .windowFullScreenBehavior(.disabled)
                .windowDismissBehavior(.disabled)
                .environment(\.appEnvironment, appEnvironment)
                .environment(networkManager)
                .onFirstTaskViewModifier {
                    networkManager.initializeNetworkManager()
                }
        }
        .getModelContainersViewModifier(
            in: appEnvironment,
            for: [
                ImageQueryURLModel.self,
                RecentImageURLModel.self
            ]
        )
        .windowResizability(.contentSize)
        //        .windowStyle(.hiddenTitleBar)
    }
}
