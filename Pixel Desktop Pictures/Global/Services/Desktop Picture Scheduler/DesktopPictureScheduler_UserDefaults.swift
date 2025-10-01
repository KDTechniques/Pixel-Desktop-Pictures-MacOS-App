//
//  DesktopPictureScheduler_UserDefaults.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-09-30.
//

import Foundation

extension DesktopPictureScheduler {
    /// Retrieves the time interval selection value from User Defaults.
    ///
    /// - Returns: The time interval selection value.
    func getTimeIntervalSelectionFromUserDefaults() async -> TimeInterval {
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
    func getExecutionTimeIntervalSince1970FromUserDefaults(otherwiseWith timeIntervalSelection: TimeInterval) async -> TimeInterval {
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
    func saveTimeIntervalSelectionToUserDefaults(from timeIntervalSelection: TimeInterval) async {
        await defaults.save(key: timeIntervalKey, value: timeIntervalSelection)
        setTimeIntervalSelection(timeIntervalSelection)
        Logger.log("✅: Time interval selection has been saved to user defaults.")
    }
    
    /// Saves the execution time interval since 1970 to User Defaults.
    ///
    /// - Parameter executionTimeIntervalSince1970: The execution time interval since 1970.
    func saveExecutionTimeSince1970ToUserDefaults(from executionTimeIntervalSince1970: TimeInterval) async {
        await defaults.save(key: executionTimeKey, value: executionTimeIntervalSince1970)
        Logger.log("✅: Execution time since 1970 has ben saved to user defaults.")
    }
    
    /// Saves the background task failure state to UserDefaults.
    ///
    /// - Parameter state: Boolean indicating whether the background task failed.
    func saveFailedBackgroundTaskStateToUserDefaults(from state: Bool) async {
        await defaults.save(key: .desktopSchedulerBackgroundTaskFailureKey, value: state)
        print("✅: Failed background task state has been saved to user defaults.")
    }
    
    /// Retrieves the state of failed background tasks from UserDefaults asynchronously.
    /// - Returns: A Boolean value indicating the state of failed background tasks.
    func getFailedBackgroundTaskStateToUserDefaults() async -> Bool {
        let state: Bool = await defaults.get(key: .desktopSchedulerBackgroundTaskFailureKey) as? Bool ?? false
        
        Logger.log("✅: Failed background task state has been returned.")
        return state
    }
}
