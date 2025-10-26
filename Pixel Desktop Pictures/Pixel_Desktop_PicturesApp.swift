//
//  Pixel_Desktop_PicturesApp.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI
import TipKit

let appEnvironment: AppEnvironment = .production  // Note: Change to `.mock` as needed

/// one api access key grands 50 request per hour, so 50 x 10 is 500  requests per hour.
let apiAccessKeys: [String] = [ // invalid key for testing purposes: 2do6EHZxsHAQ_Aprpob3hGXHaBPDGHYscSt9hPlxuIQ
    "tYJmkmA0ZXLhmoPDiGEvIJxAHjI2V9d_BY2b2ueumR8",
    "7ej27jdK3xA-t6PhPiFYfPts0jUsv-WLQxa61g0gDrI",
    "LI1BeRqbbuTbwNTDNAscF_CG0HDTxSclXOJrqZuBX9Q",
    "WNifUUadNzXFz6khL7UmV4s5rBqG7KICTVUrIWcIp8k",
    "ZMy5hQsko63OaazqDYweHOgzL4_-LHOE0fsTrAEiOW0",
    "45bPf1xzjNsvfHOngiI3ZHEHbRhOUXS3TuqRvyX_c0U",
    "cd8awUo1YKKAqZmSM_7h7VRJTsmOClsikdXwY67mNEY",
    "nVV_ujxWJ5rBPjgoxBfszkQ3bvKheTbJdKX4rLEKyb8",
    "ExtS6bLb-Ou4gX-hBVEh7wupzZR9tAZwONR86ZWXzBo",
    "w9sxe_6HWTkUq6xZHRfZHLccukzf4_hN9iKedOA5RSE",
]

@main
struct Pixel_Desktop_PicturesApp: App {
    // MARK: - INJECTED PROPETIES
    @State private var settingsTabVM: SettingsTabViewModel
    @State private var mainTabVM: MainTabViewModel
    @State private var recentsTabVM: RecentsTabViewModel
    @State private var collectionsTabVM: CollectionsTabViewModel
    @State private var apiAccessKeyManager: APIAccessKeyManager
    
    // MARK: - INITIALIZER
    init() {
        try? Tips.configure()
        
#if DEBUG
        try? Tips.resetDatastore()
#endif
        
        let apiAccessKeyManagerInstance: APIAccessKeyManager = .init()
        apiAccessKeyManager = apiAccessKeyManagerInstance
        
        // COLLECTIONS Related
        let collectionsTabVMInstance: CollectionsTabViewModel = .init(apiAccessKeyManager: apiAccessKeyManagerInstance)
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
            await apiAccessKeyManagerInstance.initializeAPIAccessKeyManager()
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
                .environment(apiAccessKeyManager)
                .environment(tabsVM)
                .environment(settingsTabVM)
                .environment(mainTabVM)
                .environment(recentsTabVM)
                .environment(collectionsTabVM)
        }
        .menuBarExtraStyle(.window)
    }
}
