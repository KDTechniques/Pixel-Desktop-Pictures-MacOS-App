//
//  Pixel_Desktop_PicturesApp.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI
import TipKit

let appEnvironment: AppEnvironment = .production  // Note: Change to `.mock` as needed

@main
struct Pixel_Desktop_PicturesApp: App {
    // MARK: - INJECTED PROPETIES
    @State private var settingsTabVM: SettingsTabViewModel
    @State private var mainTabVM: MainTabViewModel
    @State private var recentsTabVM: RecentsTabViewModel
    @State private var collectionsTabVM: CollectionsTabViewModel
    @State private var apiKeyManager: APIKeyManager
    
    // MARK: - INITIALIZER
    init() {
        try? Tips.configure()
        
#if DEBUG
        try? Tips.resetDatastore()
#endif
        
        let apiKeyManagerInstance: APIKeyManager = .init()
        apiKeyManager = apiKeyManagerInstance
        
        // COLLECTIONS Related
        let collectionsTabVMInstance: CollectionsTabViewModel = .init(apiKeyManager: apiKeyManagerInstance)
        collectionsTabVM = collectionsTabVMInstance
        
        // RECENTS Related
        let recentsTabVMInstance: RecentsTabViewModel = .init()
        recentsTabVM = recentsTabVMInstance
        
        // MAIN Tab Related
        let mainTabVMInstance: MainTabViewModel = .init(collectionsTabVM: collectionsTabVMInstance, recentsTabVM: recentsTabVMInstance)
        mainTabVM = mainTabVMInstance
        
        // SETTINGS Tab Related
        let settingsTabVMInstance: SettingsTabViewModel = .init(mainTabVM: mainTabVMInstance)
        settingsTabVM = settingsTabVMInstance
        
        
        Task {
            await apiKeyManagerInstance.initializeAPIKeyManager()
            await collectionsTabVMInstance.initializeCollectionsViewModel()
            await recentsTabVMInstance.initializeRecentsTabViewModel()
            await mainTabVMInstance.initializeMainTabViewModel()
            await settingsTabVMInstance.initializeSettingsTabVM()
        }
    }
    
    // MARK: - ASSIGNED PROPERTIES
    @State private var tabsVM: TabsViewModel = .init()
    
    // MARK: - BODY
    var body: some Scene {
        MenuBarExtra("Pixel Desktop Pictures MacOS App", image: .menuBarIcon) {
            TabsView()
                .environment(apiKeyManager)
                .environment(tabsVM)
                .environment(settingsTabVM)
                .environment(mainTabVM)
                .environment(recentsTabVM)
                .environment(collectionsTabVM)
        }
        .menuBarExtraStyle(.window)
    }
}
