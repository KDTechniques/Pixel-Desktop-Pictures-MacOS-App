//
//  AppDelegate.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-10-05.
//

import SwiftUI
import Sparkle // Note: Upload the .dmg file to GitHub repo and change the version number in .xml file

class AppDelegate: NSObject, NSApplicationDelegate {
    private let updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️")
        // Automatically check for updates when app launches
        updaterController.updater.checkForUpdatesInBackground()
    }
}
