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
    // MARK: - ASSIGNED PROPERTIES
    private let appEnvironment: AppEnvironment = .production // Note: Change to `.production` as needed
    let networkManager: NetworkManager = .shared
    @State private var tabsVM: TabsViewModel = .init()
    
    // MARK: - INJECTED PROPETIES
    @State private var apiAccessKeyManager: APIAccessKeyManager
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
            
            // COLLECTIONS Related
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
            
            // RECENTS Related
            let recentLocalDatabaseManagerInstance: RecentLocalDatabaseManager = .init(localDatabaseManager: localDatabaseManagerInstance)
            let recentManagerInstance: RecentManager = .shared(localDatabaseManager: recentLocalDatabaseManagerInstance)
            let recentsTabVMInstance: RecentsTabViewModel = .init(recentManager: recentManagerInstance)
            recentsTabVM = recentsTabVMInstance
            
            // MAIN Tab Related
            let mainTabVMInstance: MainTabViewModel = .init(collectionsTabVM: collectionsTabVMInstance, recentsTabVM: recentsTabVMInstance)
            mainTabVM = mainTabVMInstance
            
            // SETTINGS Tab Related
            settingsTabVM = .init(appEnvironment: appEnvironment, mainTabVM: mainTabVMInstance)
        } catch {
            Logger.log("❌: Unable to initialize the app properly. Due to local database initialization. \(error.localizedDescription)")
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
                    // Note: Don't change the order below
                    Task {
                        await collectionsTabVM.initializeCollectionsViewModel()
                        await mainTabVM.initializeMainTabViewModel()
                    }
                    
                    Task { await recentsTabVM.initializeRecentsTabViewModel() }
                }
        }
        .menuBarExtraStyle(.window)
    }
}
