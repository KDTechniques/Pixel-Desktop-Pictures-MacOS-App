//
//  DesktopPictureScheduler.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import SwiftUICore
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
    private let appEnvironmentType: AppEnvironment
    private var timeIntervalSelection: TimeInterval
    private let mainTabVM: MainTabViewModel
    
    // MARK: - INITIALIZER
    private init(appEnvironmentType: AppEnvironment, mainTabVM: MainTabViewModel) {
        self.appEnvironmentType = appEnvironmentType
        timeIntervalSelection = DesktopPictureSchedulerInterval.defaultTimeInterval.timeInterval(environment: appEnvironmentType)
        self.mainTabVM = mainTabVM
        
        Task { await initializeScheduler() }
    }
    
    // MARK: - ASSIGNED PROPERTIES
    private let defaults: UserDefaultsManager = .shared
    private let networkManager: NetworkManager = .shared
    private let timeIntervalKey: UserDefaultKeys = .timeIntervalDoubleKey
    private let executionTimeKey: UserDefaultKeys = .executionTimeIntervalSince1970Key
    private let taskIdentifier = "com.kdtechniques.Pixel-Desktop-Pictures.DesktopPictureScheduler.backgroundTask"
    private var scheduler: NSBackgroundActivityScheduler?
    private var currentTimeIntervalSince1970: TimeInterval { return Date().timeIntervalSince1970 }
    private(set) var didBackgroundTaskFailOnInternetFailure: Bool = false {
        didSet { didBackgroundTaskFailOnInternetFailure$ = didBackgroundTaskFailOnInternetFailure }
    }
    @ObservationIgnored @Published private var didBackgroundTaskFailOnInternetFailure$: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
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
    
    /// Subscribes to changes in the background task internet failure state.
    ///
    /// Saves the updated failure state to UserDefaults when changes occur.
    ///
    /// - Note: Uses `@MainActor` to ensure UserDefaults update happens on the main thread.
    private func didBackgroundTaskFailOnInternetFailureSubscriber() {
        $didBackgroundTaskFailOnInternetFailure$
            .dropFirst(2)
            .removeDuplicates()
            .sink { boolean in
                Task { @MainActor [weak self] in
                    guard let self else { return }
                    Logger.log("✅: Did background task fail on internet failure subscriber got triggered.")
                    await saveFailedBackgroundTaskStateToUserDefaults(from: boolean)
                }
            }
            .store(in: &cancellables)
    }
    
    /// This function schedules a background task with the specified time interval.
    /// It uses `NSBackgroundActivityScheduler` to ensure the task runs efficiently in the background.
    ///
    /// - Parameter timeInterval: The time interval (in seconds) for the scheduler.
    ///   - If `timeInterval` is `nil`, it implies that the user has triggered the task manually by opening the app.
    ///
    /// - Throws: `DesktopPictureSchedulerError.taskDeallocated`: If the task instance is deallocated during execution.
    private func scheduleBackgroundTask(with timeInterval: TimeInterval?) async throws {
        guard let timeInterval: TimeInterval else {
            // Nil `timeInterval` Value Means User Has Passed the Execution Time and Opened the App
            // So, Immediately Call the Background Task
            await performBackgroundTask()
            
            // Calculate Execution Time Interval Since 1970, Then Schedule Task, and Save to User Defaults
            await calculateScheduleSaveExecutionTimeIntervalSince1970(with: timeIntervalSelection)
            Logger.log("✅: Background task has been scheduled.")
            return
        }
        
        let activity: NSBackgroundActivityScheduler = .init(identifier: taskIdentifier)
        activity.repeats = false  // Set repeats to false so that we can accurately set intervals by calculating them for different edge cases.
        activity.interval = timeInterval
        activity.tolerance = min(activity.interval * 0.1, 30 * 60) // Max tolerance is 30 min
        activity.schedule { completion in
            Task { [weak self] in
                guard let self else {
                    Logger.log(DesktopPictureSchedulerError.taskDeallocated.localizedDescription)
                    completion(.deferred)
                    throw DesktopPictureSchedulerError.taskDeallocated
                }
                
                await performBackgroundTask()
                completion(.finished)
                Logger.log("Success: `NSBackgroundActivityScheduler` task is finished.")
                
                // Rescheduling Upon Completion as We Don't Repeat the Scheduler
                // Calculate Execution Time Interval Since 1970, Then Schedule Task, and Save to User Defaults
                await calculateScheduleSaveExecutionTimeIntervalSince1970(with: timeIntervalSelection)
            }
        }
        
        // Assign the new activity
        scheduler = activity
    }
    
    /// Executes the main background task for updating desktop pictures.
    ///
    /// This asynchronous function:
    /// - Waits for 5 seconds before execution
    /// - Fetches and sets the next desktop image
    /// - Handles network connectivity issues with automatic rescheduling
    ///
    /// The function includes error handling for:
    /// - Network connectivity issues (automatically reschedules)
    /// - General URL errors
    ///
    /// - Note: The 5-second delay helps initialize `MainTabViewModel` before calling its functions.
    /// - Important: Network failures trigger automatic rescheduling of the task.
    private func performBackgroundTask() async {
        Logger.log("Progress: Performing background task.")
        
        do {
            try await Task.sleep(nanoseconds: 5_000_000_000)
            try await mainTabVM.setNextImage()
            try await mainTabVM.setDesktopPicture(environment: appEnvironmentType)
        } catch {
            Logger.log("❌: Failed to perform background task. \(error.localizedDescription)")
            guard let urlError: URLError = error as? URLError else { return }
            
            switch urlError.code {
            case .notConnectedToInternet:
                didBackgroundTaskFailOnInternetFailure = true
                Logger.log("⚠️✅: Background task has been rescheduled to run when connected to the internet properly.")
            default: ()
            }
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

// MARK: EXTENSIONS

// MARK: - Calculations Related
extension DesktopPictureScheduler {
    /// Calculates, schedules, and saves the execution time interval since 1970.
    ///
    /// - Parameter timeIntervalSelection: The selected time interval.
    private func calculateScheduleSaveExecutionTimeIntervalSince1970(with timeIntervalSelection: TimeInterval) async {
        // Calculate Execution Time Interval Since 1970 from New Time Interval Selection Value
        let executionTimeIntervalSince1970: TimeInterval = calculateExecutionTimeIntervalSince1970(from: timeIntervalSelection)
        
        do {
            // Schedule Background Task by Time Interval Selection Value
            try await scheduleBackgroundTask(with: timeIntervalSelection)
            
            // Save Execution Time Interval Since 1970 to User Defaults
            await saveExecutionTimeSince1970ToUserDefaults(from: executionTimeIntervalSince1970)
            Logger.log("✅: Calculated, scheduled, and saved execution time interval since 1970 to user defaults.")
        } catch {
            Logger.log("\(String(describing: DesktopPictureSchedulerError.executionTimeProcessingFailed.errorDescription)) \(error.localizedDescription)")
        }
    }
    
    /// Calculates the execution time interval since 1970 based on the selected time interval.
    ///
    /// - Parameter timeIntervalSelection: The selected time interval.
    /// - Returns: The execution time interval since 1970.
    private func calculateExecutionTimeIntervalSince1970(from timeIntervalSelection: TimeInterval) -> TimeInterval {
        // Add Time Interval Selection Value to Current Date to get the Execution Time in the Future
        let executionTimeIntervalSince1970: TimeInterval = Date().addingTimeInterval(timeIntervalSelection).timeIntervalSince1970
        
        Logger.log("✅: Calculated execution time interval since 1970 has been returned.")
        return executionTimeIntervalSince1970
    }
    
    /// Calculates the time interval for the scheduler based on the execution time.
    ///
    /// - Returns: The calculated time interval for the scheduler.
    private func calculateTimeIntervalForScheduler() async -> TimeInterval? {
        let executionTimeIntervalSince1970: TimeInterval = await getExecutionTimeIntervalSince1970FromUserDefaults(otherwiseWith: timeIntervalSelection)
        
        // Calculate Time Interval for the `NSBackgroundActivityScheduler`
        let activityTimeInterval: TimeInterval = executionTimeIntervalSince1970 - currentTimeIntervalSince1970
        
        // Handle When User Has Passed the Execution Time and Opened the App
        guard activityTimeInterval > 0 else {
            return nil
        }
        
        Logger.log("✅: Calculated timer interval for the scheduler has been returned.")
        
        // Return Positive `activityTimeInterval` Value When User Opens the App Before the Execution Time
        return activityTimeInterval
    }
}

// MARK: - User Defaults Related
extension DesktopPictureScheduler {
    /// Retrieves the time interval selection value from User Defaults.
    ///
    /// - Returns: The time interval selection value.
    private func getTimeIntervalSelectionFromUserDefaults() async -> TimeInterval {
        // Try to Get Time Interval Selection Value from User Defaults
        guard let timeIntervalSelection: TimeInterval = await defaults.get(key: timeIntervalKey) as? TimeInterval else {
            // Get the Default Time Interval Value from `DesktopPictureSchedulerInterval`
            let defaultTimeInterval: TimeInterval = DesktopPictureSchedulerInterval.defaultTimeInterval.timeInterval(environment: appEnvironmentType)
            
            return defaultTimeInterval
        }
        
        Logger.log("✅: Time interval selection has been retrieved from user defaults.")
        
        // Return Saved Time Interval Selection Value from User Defaults
        return timeIntervalSelection
    }
    
    /// Retrieves the execution time interval since 1970 from User Defaults or calculates a new one if not found.
    ///
    /// - Parameter timeIntervalSelection: The selected time interval.
    /// - Returns: The execution time interval since 1970.
    private func getExecutionTimeIntervalSince1970FromUserDefaults(otherwiseWith timeIntervalSelection: TimeInterval) async -> TimeInterval {
        // Try to get Saved Execution Time Interval Since 1970 from User Defaults
        guard let savedExecutionTimeIntervalSince1970: TimeInterval = await defaults.get(key: executionTimeKey) as? TimeInterval else {
            // Create New Execution Time Interval Since 1970 on User Defaults Failure
            let newExecutionTimeIntervalSince1970: TimeInterval = calculateExecutionTimeIntervalSince1970(from: timeIntervalSelection)
            
            // Save New Execution Time Interval Since 1970 to User Defaults
            await saveExecutionTimeSince1970ToUserDefaults(from: newExecutionTimeIntervalSince1970)
            return newExecutionTimeIntervalSince1970
        }
        
        Logger.log("✅: Execution time interval since 1970 has been retrieved from user defaults.")
        
        // Return Saved Execution Time Interval Since 1970 Value from User Defaults
        return savedExecutionTimeIntervalSince1970
    }
    
    /// Saves the time interval selection value to User Defaults.
    ///
    /// - Parameter timeIntervalSelection: The selected time interval.
    private func saveTimeIntervalSelectionToUserDefaults(from timeIntervalSelection: TimeInterval) async {
        await defaults.save(key: timeIntervalKey, value: timeIntervalSelection)
        self.timeIntervalSelection = timeIntervalSelection
        Logger.log("✅: Time interval selection has been saved to user defaults.")
    }
    
    /// Saves the execution time interval since 1970 to User Defaults.
    ///
    /// - Parameter executionTimeIntervalSince1970: The execution time interval since 1970.
    private func saveExecutionTimeSince1970ToUserDefaults(from executionTimeIntervalSince1970: TimeInterval) async {
        await defaults.save(key: executionTimeKey, value: executionTimeIntervalSince1970)
        Logger.log("✅: Execution time since 1970 has ben saved to user defaults.")
    }
    
    /// Saves the background task failure state to UserDefaults.
    ///
    /// - Parameter state: Boolean indicating whether the background task failed.
    private func saveFailedBackgroundTaskStateToUserDefaults(from state: Bool) async {
        await defaults.save(key: .desktopSchedulerBackgroundTaskFailureKey, value: state)
        print("✅: Failed background task state has been saved to user defaults.")
    }
    
    /// Retrieves the state of failed background tasks from UserDefaults asynchronously.
    /// - Returns: A Boolean value indicating the state of failed background tasks.
    private func getFailedBackgroundTaskStateToUserDefaults() async -> Bool {
        let state: Bool = await defaults.get(key: .desktopSchedulerBackgroundTaskFailureKey) as? Bool ?? false
        
        Logger.log("✅: Failed background task state has been returned.")
        return state
    }
}
