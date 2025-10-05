//
//  Pixel_Desktop_PicturesApp.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI
import Sparkle

/// one api access key grands 50 request per hour, so 50 x 10 is 500  requests per hour.
let apiAccessKeys: [String] = [
    "7ej27jdK3xA-t6PhPiFYfPts0jUsv-WLQxa61g0gDrI",
//    "LI1BeRqbbuTbwNTDNAscF_CG0HDTxSclXOJrqZuBX9Q",
//    "WNifUUadNzXFz6khL7UmV4s5rBqG7KICTVUrIWcIp8k",
//    "ZMy5hQsko63OaazqDYweHOgzL4_-LHOE0fsTrAEiOW0",
//    "45bPf1xzjNsvfHOngiI3ZHEHbRhOUXS3TuqRvyX_c0U",
//    "cd8awUo1YKKAqZmSM_7h7VRJTsmOClsikdXwY67mNEY",
//    "nVV_ujxWJ5rBPjgoxBfszkQ3bvKheTbJdKX4rLEKyb8",
//    "ExtS6bLb-Ou4gX-hBVEh7wupzZR9tAZwONR86ZWXzBo",
//    "tYJmkmA0ZXLhmoPDiGEvIJxAHjI2V9d_BY2b2ueumR8",
//    "w9sxe_6HWTkUq6xZHRfZHLccukzf4_hN9iKedOA5RSE",
]

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
    
    class AppDelegate: NSObject, NSApplicationDelegate {
        private let updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        
        func applicationDidFinishLaunching(_ notification: Notification) {
            // Automatically check for updates when app launches
            updaterController.updater.checkForUpdatesInBackground()
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
