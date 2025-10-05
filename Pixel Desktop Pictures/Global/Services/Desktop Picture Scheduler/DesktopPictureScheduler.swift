//
//  DesktopPictureScheduler.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import SwiftUI
import Combine

/**
 The `DesktopPictureScheduler` class is responsible for managing the scheduling of desktop picture updates.
 It allows for configuring the time intervals for when desktop pictures should be changed and ensures the task is performed in the background using `NSBackgroundActivityScheduler`.
 */
@MainActor
final class DesktopPictureScheduler {
    // MARK: - SINGLETON
    private static var singleton: DesktopPictureScheduler?
    
    // MARK: - INJECTED PROPERTIES
    let appEnvironmentType: AppEnvironment
    private(set) var timeIntervalSelection: TimeInterval
    let mainTabVM: MainTabViewModel
    
    // MARK: - INITIALIZER
    private init(appEnvironmentType: AppEnvironment, mainTabVM: MainTabViewModel) {
        self.appEnvironmentType = appEnvironmentType
        timeIntervalSelection = DesktopPictureSchedulerInterval.defaultTimeInterval.timeInterval(environment: appEnvironmentType)
        self.mainTabVM = mainTabVM
        
        Task { await initializeScheduler() }
    }
    
    // MARK: - ASSIGNED PROPERTIES
    let defaults: UserDefaultsManager = .shared
    private let networkManager: NetworkManager = .shared
    let timeIntervalKey: UserDefaultKeys = .timeIntervalDoubleKey
    let executionTimeKey: UserDefaultKeys = .executionTimeIntervalSince1970Key
    let taskIdentifier = "com.kdtechniques.Pixel-Desktop-Pictures.DesktopPictureScheduler.backgroundTask"
    private(set) var scheduler: NSBackgroundActivityScheduler?
    var currentTimeIntervalSince1970: TimeInterval { return Date().timeIntervalSince1970 }
    private(set) var didBackgroundTaskFailOnInternetFailure: Bool = false {
        didSet { didBackgroundTaskFailOnInternetFailure$ = didBackgroundTaskFailOnInternetFailure }
    }
    @ObservationIgnored @Published var didBackgroundTaskFailOnInternetFailure$: Bool = false
    @ObservationIgnored var cancellables: Set<AnyCancellable> = []
    
    // MARK: - SETTERS
    
    func setTimeIntervalSelection(_ value: TimeInterval) {
        timeIntervalSelection = value
    }
    
    func setDidBackgroundTaskFailOnInternetFailure(_ value: Bool) {
        didBackgroundTaskFailOnInternetFailure = value
    }
    
    func setScheduler(_ value:NSBackgroundActivityScheduler?) {
        scheduler = value
    }
    
    
    // MARK: - INTERNAL FUNCTIONS
    
    /// Returns the shared singleton instance of `DesktopPictureScheduler`.
    ///
    /// This function ensures that only one instance of `DesktopPictureScheduler` is created.
    /// If the singleton instance is already created, it is returned.
    /// Otherwise, a new instance is created, stored, and then returned. This ensures that the app
    /// uses a single instance for managing the desktop picture scheduling process.
    ///
    /// - Parameter appEnvironmentType: The type of the app's environment, which is passed to the
    ///   `DesktopPictureScheduler` initializer to configure the scheduler for the correct environment.
    ///
    /// - Returns: The shared `DesktopPictureScheduler` instance.
    static func shared(appEnvironmentType: AppEnvironment, mainTabVM: MainTabViewModel) -> DesktopPictureScheduler {
        guard singleton == nil else {
            return singleton!
        }
        
        let newInstance: DesktopPictureScheduler = .init(appEnvironmentType: appEnvironmentType, mainTabVM: mainTabVM)
        singleton = newInstance
        return newInstance
    }
    
    /// Handles changes to the time interval selection.
    ///
    /// - Parameter timeInterval: The new time interval selection.
    func onChangeOfTimeIntervalSelection(from timeInterval: DesktopPictureSchedulerInterval) async {
        // Save Time Interval Selection Value to User Defaults
        let timeIntervalSelection: TimeInterval = timeInterval.timeInterval(environment: appEnvironmentType)
        await saveTimeIntervalSelectionToUserDefaults(from: timeIntervalSelection)
        
        // Calculate Execution Time Interval Since 1970, Then Schedule Task, and Save to User Defaults
        await calculateScheduleSaveExecutionTimeIntervalSince1970(with: timeIntervalSelection)
        Logger.log("✅: Time interval has been changed by the user.")
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Initializes the scheduler by setting the time interval and scheduling the background task.
    private func initializeScheduler() async {
        didBackgroundTaskFailOnInternetFailureSubscriber()
        networkConnectionSubscriber()
        
        didBackgroundTaskFailOnInternetFailure = await getFailedBackgroundTaskStateToUserDefaults()
        
        // Assign Time Interval Selection Value to A Property to Avoid Using User Defaults Most of the Time
        let timeIntervalSelection: TimeInterval = await getTimeIntervalSelectionFromUserDefaults()
        self.timeIntervalSelection = timeIntervalSelection
        
        let timeIntervalForScheduler: TimeInterval? = await calculateTimeIntervalForScheduler()
        
        do {
            Logger.log("✅: `Desktop Picture Scheduler` has been initialized")
            try await scheduleBackgroundTask(with: timeIntervalForScheduler)
        } catch {
            Logger.log("\(String(describing: DesktopPictureSchedulerError.activitySchedulingFailed.errorDescription)) \(error.localizedDescription)")
        }
    }
    
    /// Monitors network connectivity changes and retries failed background tasks.
    ///
    /// This function sets up a Combine subscriber that:
    /// - Observes changes in network connection status
    /// - Filters out duplicate status updates
    /// - Retries previously failed background tasks when internet connectivity is restored
    ///
    /// The retry mechanism:
    /// - Only triggers if a previous task failed specifically due to internet connectivity
    /// - Resets the failure flag after attempting retry
    /// - Executes the retry on a background task to prevent blocking
    ///
    /// - Note: Uses weak references to prevent retain cycles in the closure and task.
    /// - Important: Only retries tasks that failed due to internet connectivity issues.
    private func networkConnectionSubscriber() {
        networkManager.$connectionStatus$
            .removeDuplicates()
            .sink { [weak self] status in
                // Try to perform failed background task due to internet failure again only if the `didBackgroundTaskFailOnInternetFailure` is true.
                guard let self, didBackgroundTaskFailOnInternetFailure else { return }
                
                // Change the state to false
                self.didBackgroundTaskFailOnInternetFailure = false
                
                Logger.log("⚠️✅: Performing failed background task on internet failure again.")
                
                // Perform the failed background task again.
                Task { [weak self] in
                    await self?.performBackgroundTask()
                }
            }
            .store(in: &cancellables)
    }
}
