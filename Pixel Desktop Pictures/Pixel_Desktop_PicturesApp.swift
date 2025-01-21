//
//  Pixel_Desktop_PicturesApp.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI

@main
struct Pixel_Desktop_PicturesApp: App {
    // MARK: - PROPERTIES
    private let appEnvironment: AppEnvironmentModel = .production // Note: Change to `.production` as needed
    
    // Services
    let networkManager: NetworkManager = .shared
    @State private var apiAccessKeyManager: APIAccessKeyManager
    
    // Tabs
    @State private var tabsVM: TabsViewModel = .init()
    @State private var settingsTabVM: SettingsTabViewModel
    @State private var mainTabVM: MainTabViewModel
    @State private var recentsTabVM: RecentsTabViewModel
    @State private var collectionsTabVM: CollectionsTabViewModel
    
    // MARK: - INITIALIZER
    init() {
        let apiAccessKeyManagerInstance: APIAccessKeyManager = .init()
        apiAccessKeyManager = apiAccessKeyManagerInstance
        
        do {
            let localDatabaseManagerInstance: LocalDatabaseManager = try .init(appEnvironment: appEnvironment)
            
            // Collections Related
            let collectionLocalDatabaseManagerInstance: CollectionLocalDatabaseManager = .init(localDatabaseManager: localDatabaseManagerInstance)
            let collectionManagerInstance: CollectionManager = .shared(localDatabaseManager: collectionLocalDatabaseManagerInstance)
            let queryImageLocalDatabaseManagerInstance: QueryImageLocalDatabaseManager = .init(localDatabaseManager: localDatabaseManagerInstance)
            let queryImageManagerInstance: QueryImageManager = .shared(localDatabaseManager: queryImageLocalDatabaseManagerInstance)
            let collectionsTabVMInstance: CollectionsTabViewModel = .init(
                apiAccessKeyManager: apiAccessKeyManagerInstance,
                collectionManager: collectionManagerInstance,
                queryImageManager: queryImageManagerInstance
            )
            collectionsTabVM = collectionsTabVMInstance
            
            // Recents Related
            let recentLocalDatabaseManagerInstance: RecentLocalDatabaseManager = .init(localDatabaseManager: localDatabaseManagerInstance)
            let recentManagerInstance: RecentManager = .shared(localDatabaseManager: recentLocalDatabaseManagerInstance)
            let recentsTabVMInstance: RecentsTabViewModel = .init(recentManager: recentManagerInstance)
            recentsTabVM = recentsTabVMInstance
            
            // Main tab Related
            let mainTabVMInstance: MainTabViewModel = .init(collectionsTabVM: collectionsTabVMInstance, recentsTabVM: recentsTabVMInstance)
            mainTabVM = mainTabVMInstance
            
            // Settings Tab Related
            settingsTabVM = .init(appEnvironment: appEnvironment, mainTabVM: mainTabVMInstance)
        } catch {
            print("❌: Unable to initialize the app properly. Due to local database initialization. \(error.localizedDescription)")
            fatalError()
        }
    }
    
    // MARK: - BODY
    var body: some Scene {
        MenuBarExtra("Pixel Desktop Pictures MacOS App", image: .logo) {
            TabsView()
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
                    Task { await apiAccessKeyManager.initializeAPIAccessKeyManager() }
                    
                    // MARK: - Tabs Initializations
                    Task { await settingsTabVM.initializeSettingsTabVM() }
                    Task { await collectionsTabVM.initializeCollectionsViewModel() }
                    Task { await mainTabVM.initializeMainTabViewModel() }
                    Task { await recentsTabVM.initializeRecentsTabViewModel() }
                }
        }
        .menuBarExtraStyle(.window)
    }
}
