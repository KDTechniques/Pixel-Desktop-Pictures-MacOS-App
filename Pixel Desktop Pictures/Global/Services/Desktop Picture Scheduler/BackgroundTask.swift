//
//  BackgroundTask.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-09-30.
//

import Foundation

extension DesktopPictureScheduler {
    /// Subscribes to changes in the background task internet failure state.
    ///
    /// Saves the updated failure state to UserDefaults when changes occur.
    ///
    /// - Note: Uses `@MainActor` to ensure UserDefaults update happens on the main thread.
    func didBackgroundTaskFailOnInternetFailureSubscriber() {
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
    func scheduleBackgroundTask(with timeInterval: TimeInterval?) async throws {
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
        setScheduler(activity)
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
    func performBackgroundTask() async {
        Logger.log("Progress: Performing background task.")
        
        do {
            try await Task.sleep(nanoseconds: 5_000_000_000)
            try await mainTabVM.setNextImage()
            try await mainTabVM.setDesktopPicture()
        } catch {
            Logger.log("❌: Failed to perform background task. \(error.localizedDescription)")
            guard let urlError: URLError = error as? URLError else { return }
            
            switch urlError.code {
            case .notConnectedToInternet:
                setDidBackgroundTaskFailOnInternetFailure(true)
                Logger.log("⚠️✅: Background task has been rescheduled to run when connected to the internet properly.")
            default: ()
            }
        }
    }
}
