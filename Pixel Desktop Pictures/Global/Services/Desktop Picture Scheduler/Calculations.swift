//
//  Calculations.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-09-30.
//

import Foundation

extension DesktopPictureScheduler {
    /// Calculates, schedules, and saves the execution time interval since 1970.
    ///
    /// - Parameter timeIntervalSelection: The selected time interval.
    func calculateScheduleSaveExecutionTimeIntervalSince1970(with timeIntervalSelection: TimeInterval) async {
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
    func calculateExecutionTimeIntervalSince1970(from timeIntervalSelection: TimeInterval) -> TimeInterval {
        // Add Time Interval Selection Value to Current Date to get the Execution Time in the Future
        let executionTimeIntervalSince1970: TimeInterval = Date().addingTimeInterval(timeIntervalSelection).timeIntervalSince1970
        
        Logger.log("✅: Calculated execution time interval since 1970 has been returned.")
        return executionTimeIntervalSince1970
    }
    
    /// Calculates the time interval for the scheduler based on the execution time.
    ///
    /// - Returns: The calculated time interval for the scheduler.
    func calculateTimeIntervalForScheduler() async -> TimeInterval? {
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
