//
//  SettingsTabViewModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import AppKit
import Combine
import SwiftUI

@MainActor
@Observable final class SettingsTabViewModel {
    // MARK: - INJECTED PROPERTIES
    let desktopPictureScheduler: DesktopPictureScheduler
    
    // MARK: - ASSIGNED PROPERTIES
    let desktopPictureManager: DesktopPictureManager = .shared
    
    var launchAtLogin: Bool = false {
        didSet { launchAtLogin$ = launchAtLogin }
    }
    @ObservationIgnored @Published private(set) var launchAtLogin$: Bool = false
    
    var showOnAllSpaces: Bool = true {
        didSet { showOnAllSpaces$ = showOnAllSpaces  }
    }
    @ObservationIgnored @Published private(set) var showOnAllSpaces$: Bool = true
    
    var updateIntervalSelection: DesktopPictureSchedulerInterval = .defaultTimeInterval {
        didSet { updateIntervalSelection$ = updateIntervalSelection }
    }
    @ObservationIgnored @Published private(set) var updateIntervalSelection$: DesktopPictureSchedulerInterval = .defaultTimeInterval
    
    let defaults: UserDefaultsManager = .init()
    let vmError = SettingsTabViewModelError.self
    @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    
    // MARK: - INITIALIZER
    init(mainTabVM: MainTabViewModel) {
        desktopPictureScheduler = .init(mainTabVM: mainTabVM)
    }
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Initializes the ViewModel for the Settings tab.
    ///
    /// This asynchronous function handles the setup of the Settings tab ViewModel by:
    /// - Setting up subscribers for update interval changes
    /// - Loading user settings from UserDefaults
    ///
    /// - Throws: `vmError` if initialization fails
    /// - Note: Settings are persisted using UserDefaults and loaded on initialization
    func initializeSettingsTabVM() async {
        await desktopPictureScheduler.initializeScheduler()
        
        do {
            updateIntervalSelectionSubscriber()
            showOnAllSpacesSubscriber()
            launchAtLoginSubscriber()
            try getSettingsFromUserDefaults()
            Logger.log("✅: Initialized `Settings Tab View Model`.")
        } catch {
            Logger.log(vmError.failedToInitializeSettingsTabViewModel(error).localizedDescription)
        }
    }
    
    /// Restores the default settings and saves them to UserDefaults.
    ///
    /// This function resets the settings to their default values and ensures these values are
    /// saved to UserDefaults. The settings include launch behavior, display preferences, and update interval.
    ///
    /// - Note: Calling this function will also update the settings stored in UserDefaults.
    func restoreDefaultSettings() {
        launchAtLogin = true
        showOnAllSpaces = true
        updateIntervalSelection = .defaultTimeInterval
        Logger.log("✅: Restored defaults settings.")
    }
    
    /// Quits the application.
    ///
    /// This function terminates the running application by invoking the `terminate` method
    /// on the shared `NSApplication` instance.
    func quitApp() {
        NSApplication.shared.terminate(nil)
        Logger.log("✅: App has been quit.")
    }
    
    func handleLaunchAtLoginAlertOnTabViewAppear() {
        guard defaults.get(key: .launchAtLoginAlert) as? Bool == nil else { return }
        
        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            LaunchAtLoginAlertModel.showLaunchAtLoginAlert { launchAtLogin = true }
            defaults.save(key: .launchAtLoginAlert, value: true)
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Handles changes to the update interval setting.
    ///
    /// This asynchronous function is called when the update interval setting is changed. It updates
    /// the `desktopPictureScheduler` with the new interval value.
    ///
    /// - Parameter value: The new `DesktopPictureSchedulerInterval` representing the updated update interval selection.
    private func onUpdateIntervalChange(_ value: DesktopPictureSchedulerInterval) async {
        await desktopPictureScheduler.onChangeOfTimeIntervalSelection(from: value)
        Logger.log("✅: Changed update interval.")
    }
}
