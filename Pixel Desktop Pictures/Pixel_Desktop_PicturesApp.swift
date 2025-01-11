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
    private let appEnvironment: AppEnvironmentModel = .production // Note: Change to `.production` as needed
    
    // Services
    @State private var networkManager: NetworkManager = .init()
    @State private var apiAccessKeyManager: APIAccessKeyManager
    
    // Tabs
    @State private var tabsVM: TabsViewModel = .init()
    @State private var settingsTabVM: SettingsTabViewModel
    @State private var mainTabVM: MainTabViewModel = .init()
    @State private var recentsTabVM: RecentsTabViewModel = .init()
    @State private var collectionsTabVM: CollectionsViewModel
    
    // MARK: - INITIALIZER
    init() {
        settingsTabVM = .init(appEnvironment: appEnvironment)
        
        do {
            let tempSwiftDataManager: SwiftDataManager = try .init(appEnvironment: appEnvironment)
            let tempAPIAccessKeyManager: APIAccessKeyManager = .init()
            apiAccessKeyManager = tempAPIAccessKeyManager
            
            collectionsTabVM = .init(
                apiAccessKeyManager: tempAPIAccessKeyManager,
                swiftDataManager: .init(swiftDataManager: tempSwiftDataManager)
            )
        } catch {
            print("Error: Unable to initialize the app properly. You may encounter unexpected behaviors from now on. \(error.localizedDescription)")
            // Fallback code goes here..
#if DEBUG
            fatalError()
#endif
        }
    }
    
    // MARK: - BODY
    var body: some Scene {
        WindowGroup {
            TabsView()
                .windowResizeBehavior(.disabled)
                .windowMinimizeBehavior(.disabled)
                .windowFullScreenBehavior(.disabled)
                .windowDismissBehavior(.disabled)
            // Service Environment Values
                .environment(\.appEnvironment, appEnvironment)
                .environment(networkManager)
                .environment(apiAccessKeyManager)
            // Tabs Environment Values
                .environment(tabsVM)
                .environment(settingsTabVM)
                .environment(mainTabVM)
                .environment(recentsTabVM)
                .environment(collectionsTabVM)
                .onFirstTaskViewModifier {
                    // MARK: - Service Initializations
                    networkManager.initializeNetworkManager()
                    
                    Task {
                        do {
                            try await apiAccessKeyManager.initializeAPIAccessKeyManager()
                        } catch {
                            print("Error: Initializing `API Access Key Manager`, \(error.localizedDescription)")
                        }
                    }
                    
                    // MARK: - Tabs Initializations
                    Task {
                        do {
                            try await settingsTabVM.initializeSettingsTabVM()
                        } catch {
                            print("Error: Initializing `Settings Tab View Model`, \(error.localizedDescription)")
                        }
                    }
                    
                    Task { await collectionsTabVM.initializeCollectionsViewModel() }
                }
        }
        .windowResizability(.contentSize)
        //        .windowStyle(.hiddenTitleBar)
    }
}
