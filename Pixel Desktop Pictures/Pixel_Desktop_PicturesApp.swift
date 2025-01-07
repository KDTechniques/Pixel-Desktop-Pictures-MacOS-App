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
    @State private var apiAccessKeyManager: APIAccessKeyManager = .init()
    @State private var tabsVM: TabsViewModel = .init()
    @State private var settingsTabVM: SettingsTabViewModel
    @State private var mainTabVM: MainTabViewModel = .init()
    @State private var recentsTabVM: RecentsTabViewModel = .init()
    @State private var collectionsTabVM: CollectionsViewModel = .init()
    
    // MARK: - INITIALIZER
    init() {
        settingsTabVM = .init(appEnvironment: appEnvironment)
    }
    
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
                .environment(apiAccessKeyManager)
                .environment(tabsVM)
                .environment(settingsTabVM)
                .environment(mainTabVM)
                .environment(recentsTabVM)
                .environment(collectionsTabVM)
                .onFirstTaskViewModifier {
                    networkManager.initializeNetworkManager()
                    
                    do {
                        try await settingsTabVM.initializeSettingsTabVM()
                    } catch {
                        print("Error: Initializing `Settings Tab View Model`, \(error.localizedDescription)")
                    }
                    
                    do {
                        try await apiAccessKeyManager.initializeAPIAccessKeyManager()
                    } catch {
                        print("Error: Initializing `API Access Key Manager`, \(error.localizedDescription)")
                    }
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
