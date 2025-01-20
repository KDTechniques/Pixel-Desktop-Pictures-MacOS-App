//
//  DesktopPictureScheduler.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import SwiftUICore

/**
 The `DesktopPictureScheduler` class is responsible for managing the scheduling of desktop picture updates. It allows for configuring the time intervals for when desktop pictures should be changed and ensures the task is performed in the background using `NSBackgroundActivityScheduler`.
 */
@MainActor
final class DesktopPictureScheduler {
    // MARK: - SINGLETON
    private static var singleton: DesktopPictureScheduler?
    
    // MARK: - INJECTED PROPERTIES
    private let appEnvironmentType: AppEnvironmentModel
    private var timeIntervalSelection: TimeInterval
    private let mainTabVM: MainTabViewModel
    
    // MARK: - ASSIGNED PROPERTIES
    private let defaults: UserDefaultsManager = .shared
    private let timeIntervalKey: UserDefaultKeys = .timeIntervalDoubleKey
    private let executionTimeKey: UserDefaultKeys = .executionTimeIntervalSince1970Key
    private let taskIdentifier = "com.kdtechniques.Pixel-Desktop-Pictures.DesktopPictureScheduler.backgroundTask"
    private var scheduler: NSBackgroundActivityScheduler?
    private var currentTimeIntervalSince1970: TimeInterval { return Date().timeIntervalSince1970 }
    
    // MARK: - INITIALIZER
    private init(appEnvironmentType: AppEnvironmentModel, mainTabVM: MainTabViewModel) {
        self.appEnvironmentType = appEnvironmentType
        timeIntervalSelection = DesktopPictureSchedulerIntervalsModel.defaultTimeInterval.timeInterval(environment: appEnvironmentType)
        self.mainTabVM = mainTabVM
        
        Task { await initializeScheduler() }
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
    static func shared(appEnvironmentType: AppEnvironmentModel, mainTabVM: MainTabViewModel) -> DesktopPictureScheduler {
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
    func onChangeOfTimeIntervalSelection(from timeInterval: DesktopPictureSchedulerIntervalsModel) async {
        // Save Time Interval Selection Value to User Defaults
        let timeIntervalSelection: TimeInterval = timeInterval.timeInterval(environment: appEnvironmentType)
        await saveTimeIntervalSelectionToUserDefaults(from: timeIntervalSelection)
        
        // Calculate Execution Time Interval Since 1970, Then Schedule Task, and Save to User Defaults
        await calculateScheduleSaveExecutionTimeIntervalSince1970(with: timeIntervalSelection)
        print("✅: Time interval has been changed by the user successfully. ❤️")
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    /// Initializes the scheduler by setting the time interval and scheduling the background task.
    private func initializeScheduler() async {
        // Assign Time Interval Selection Value to A Property to Avoid Using User Defaults Most of the Time
        let timeIntervalSelection: TimeInterval = await getTimeIntervalSelectionFromUserDefaults()
        self.timeIntervalSelection = timeIntervalSelection
        
        let timeIntervalForScheduler: TimeInterval? = await calculateTimeIntervalForScheduler()
        
        do {
            print("✅: `Desktop Picture Scheduler` has been initialized successfully.")
            try await scheduleBackgroundTask(with: timeIntervalForScheduler)
        } catch {
            print("\(String(describing: DesktopPictureSchedulerErrorModel.activitySchedulingFailed.errorDescription)) \(error.localizedDescription)")
        }
    }
    
    /// This function schedules a background task with the specified time interval.
    /// It uses `NSBackgroundActivityScheduler` to ensure the task runs efficiently in the background.
    ///
    /// - Parameter timeInterval: The time interval (in seconds) for the scheduler.
    ///   - If `timeInterval` is `nil`, it implies that the user has triggered the task manually by opening the app.
    ///
    /// - Throws: `DesktopPictureSchedulerErrorModel.taskDeallocated`: If the task instance is deallocated during execution.
    private func scheduleBackgroundTask(with timeInterval: TimeInterval?) async throws {
        guard let timeInterval: TimeInterval else {
            // Nil `timeInterval` Value Means User Has Passed the Execution Time and Opened the App
            // So, Immediately Call the Background Task
            await performBackgroundTask()
            
            // Calculate Execution Time Interval Since 1970, Then Schedule Task, and Save to User Defaults
            await calculateScheduleSaveExecutionTimeIntervalSince1970(with: timeIntervalSelection)
            return
        }
        
        let activity: NSBackgroundActivityScheduler = .init(identifier: taskIdentifier)
        activity.repeats = false  // Set repeats to false so that we can accurately set intervals by calculating them for different edge cases.
        activity.interval = timeInterval
        activity.tolerance = min(activity.interval * 0.1, 30 * 60) // Max tolerance is 30 min
        activity.schedule { completion in
            Task { [weak self] in
                guard let self else {
                    print("❌: `NSBackgroundActivityScheduler` task is deallocated.")
                    completion(.deferred)
                    throw DesktopPictureSchedulerErrorModel.taskDeallocated
                }
                
                await performBackgroundTask()
                completion(.finished)
                print("Success: `NSBackgroundActivityScheduler` task is finished.")
                
                // Rescheduling Upon Completion as We Don't Repeat the Scheduler
                // Calculate Execution Time Interval Since 1970, Then Schedule Task, and Save to User Defaults
                await calculateScheduleSaveExecutionTimeIntervalSince1970(with: timeIntervalSelection)
            }
        }
        
        // Assign the new activity
        scheduler = activity
    }
    
    /// Performs the background task.
    private func performBackgroundTask() async {
        print("Progress: Performing background task.")
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        await mainTabVM.setNextImage()
        await mainTabVM.setDesktopPicture()
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
        } catch {
            print("\(String(describing: DesktopPictureSchedulerErrorModel.executionTimeProcessingFailed.errorDescription)) \(error.localizedDescription)")
        }
    }
    
    /// Calculates the execution time interval since 1970 based on the selected time interval.
    ///
    /// - Parameter timeIntervalSelection: The selected time interval.
    /// - Returns: The execution time interval since 1970.
    private func calculateExecutionTimeIntervalSince1970(from timeIntervalSelection: TimeInterval) -> TimeInterval {
        // Add Time Interval Selection Value to Current Date to get the Execution Time in the Future
        let executionTimeIntervalSince1970: TimeInterval = Date().addingTimeInterval(timeIntervalSelection).timeIntervalSince1970
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
            // Get the Default Time Interval Value from `DesktopPictureSchedulerIntervalsModel`
            let defaultTimeInterval: TimeInterval = DesktopPictureSchedulerIntervalsModel.defaultTimeInterval.timeInterval(environment: appEnvironmentType)
            
            return defaultTimeInterval
        }
        
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
        
        // Return Saved Execution Time Interval Since 1970 Value from User Defaults
        return savedExecutionTimeIntervalSince1970
    }
    
    /// Saves the time interval selection value to User Defaults.
    ///
    /// - Parameter timeIntervalSelection: The selected time interval.
    private func saveTimeIntervalSelectionToUserDefaults(from timeIntervalSelection: TimeInterval) async {
        await defaults.save(key: timeIntervalKey, value: timeIntervalSelection)
        self.timeIntervalSelection = timeIntervalSelection
    }
    
    /// Saves the execution time interval since 1970 to User Defaults.
    ///
    /// - Parameter executionTimeIntervalSince1970: The execution time interval since 1970.
    private func saveExecutionTimeSince1970ToUserDefaults(from executionTimeIntervalSince1970: TimeInterval) async {
        await defaults.save(key: executionTimeKey, value: executionTimeIntervalSince1970)
    }
}
