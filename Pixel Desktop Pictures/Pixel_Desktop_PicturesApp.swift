//
//  Pixel_Desktop_PicturesApp.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI
import TipKit
import AppKit

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
        let mainTabVMInstance: MainTabViewModel = .init(
            collectionsTabVM: collectionsTabVMInstance,
            recentsTabVM: recentsTabVMInstance,
            apiKeyManager: apiKeyManagerInstance
        )
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
    @AppStorage("isInitialLaunch") private var isInitialLaunch = true
    @State private var tabsVM: TabsViewModel = .init()
    
    // MARK: - BODY
    var body: some Scene {
        WindowGroup {
            VStack {
                Button("Get Started") {
                    if let window = NSApplication.shared.keyWindow {
                        window.close()
                        isInitialLaunch = false
                    }
                }
                
                Rectangle()
                    .fill(.red)
            }
        }
        .windowStyle(.plain)
        .defaultLaunchBehavior(isInitialLaunch ? .presented : .suppressed)
        
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
