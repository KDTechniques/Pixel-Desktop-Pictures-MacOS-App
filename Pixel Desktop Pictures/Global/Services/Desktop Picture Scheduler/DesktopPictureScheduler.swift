//
//  DesktopPictureScheduler.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

actor DesktopPictureScheduler {
    // MARK: - INJECTED PROPERTIES
    private let timeInterval: DesktopPictureSchedulerIntervalsProtocol.Type
    private let backgroundTask: () -> ()
    
    // MARK: - ASSIGNED PROPERTIES
    private let defaults: UserDefaultsManager = .init()
    private let timeIntervalKey: String = UserDefaultKeys.timeInterval.rawValue
    private let initialTimeKey: String = UserDefaultKeys.initialTime.rawValue
    private let taskIdentifier = "com.kdtechniques.Pixel-Desktop-Pictures.DesktopPictureScheduler.backgroundTask"
    private var scheduler: NSBackgroundActivityScheduler?
    
    // MARK: - INITIALIZER
    init(timeIntervalModel: DesktopPictureSchedulerIntervalsProtocol.Type, backgroundTask: @escaping () -> ()) {
        self.timeInterval = timeIntervalModel
        self.backgroundTask = backgroundTask
        
        Task { await initializeScheduler() }
    }
    
    // MARK: FUNCTIONS
    
    // MARK: INTERNAL FUNCTIONS
    
    // MARK: - Update Scheduler Interval
    /// Updates the scheduler's interval.
    /// - Parameter timeInterval: The new time interval for scheduling.
    func updateSchedulerInterval(to timeInterval: DesktopPictureSchedulerIntervalsProtocol) async {
        let timeInterval: TimeInterval = timeInterval.timeInterval
        
        await setTimeIntervalToUserDefaults(with: timeInterval)
        await setInitialTimeToUserDefaults()
        await scheduleBackgroundTask(with: timeInterval)
    }
    
    // remove the following function later, as it no longer need after testing.
    func printCurrentTimeInterval() {
        print(scheduler?.interval)
    }
    
    // MARK: PRIVATE FUNCTIONS
    
    // MARK: - Initialize Scheduler
    /// Initializes the scheduler with the time interval from user defaults.
    private func initializeScheduler() async {
        let timeInterval: TimeInterval = await getTimeIntervalFromUserDefaults()
        let nextExecutionTime: TimeInterval = await calculateNextExecutionTime(with: timeInterval)
        
        // Check if the next execution time has already passed
        let now: TimeInterval = Date().timeIntervalSince1970
        if now >= nextExecutionTime {
            // Execute the missed task immediately
            print("Executed immediately❤️, Testings are over...")
            await performBackgroundTask()
            await setInitialTimeToUserDefaults() // Reset the initial time after execution
        }
        
        await scheduleBackgroundTask(with: timeInterval)
    }
    
    // MARK: - Schedule Background Task
    /// Creates a new activity with the specified time interval.
    private func scheduleBackgroundTask(with timeInterval: TimeInterval) async {
        let nextExecutionTime: TimeInterval = await calculateNextExecutionTime(with: timeInterval)
        let activity: NSBackgroundActivityScheduler = .init(identifier: taskIdentifier)
        activity.repeats = false  // Set repeats to false
        activity.interval = nextExecutionTime - Date().timeIntervalSince1970
        activity.tolerance = min(activity.interval * 0.1, 30 * 60) // Max tolerance is 30 min
        activity.schedule { completion in
            Task {
                await self.performBackgroundTask()
                completion(.finished)
                await self.resetScheduler()
            }
        }
        
        // Assign the new activity
        self.scheduler = activity
    }
    
    // MARK: - Perform Background Task
    /// Performs the background task.
    private func performBackgroundTask() async {
        backgroundTask()
    }
    
    // MARK: - Reset Scheduler
    /// Resets the scheduler by recalculating the interval and setting the initial time.
    private func resetScheduler() async {
        let timeInterval = await getTimeIntervalFromUserDefaults()
        await setInitialTimeToUserDefaults()
        await scheduleBackgroundTask(with: timeInterval)
    }
    
    // MARK: - Get Time Interval from User Defaults
    /// Gets the time interval from user defaults.
    /// - Returns: The time interval from user defaults, or the default time interval if not set.
    private func getTimeIntervalFromUserDefaults() async -> TimeInterval {
        guard let timeInterval = await defaults.get(key: timeIntervalKey) as? Double else {
            return timeInterval.defaultTimeInterval
        }
        return timeInterval
    }
    
    // MARK: - Set Time Interval to User Defaults
    /// Sets the time interval to user defaults.
    /// - Parameter timeInterval: The time interval to be saved to user defaults.
    private func setTimeIntervalToUserDefaults(with timeInterval: TimeInterval) async {
        await defaults.save(key: timeIntervalKey, value: timeInterval)
    }
    
    // MARK: - Set Initial Time to User Defaults
    /// Sets the initial time to user defaults.
    private func setInitialTimeToUserDefaults() async {
        let initialTime = Date().timeIntervalSince1970
        await defaults.save(key: initialTimeKey, value: initialTime)
    }
    
    // MARK: - Get Initial Time from User Defaults
    /// Gets the initial time from user defaults.
    /// - Returns: The initial time from user defaults, or the current time if not set.
    private func getInitialTimeFromUserDefaults() async -> TimeInterval {
        guard let initialTime = await defaults.get(key: initialTimeKey) as? Double else {
            return Date().timeIntervalSince1970
        }
        return initialTime
    }
    
    // MARK: - Calculate Next Execution Time
    /// Calculates the next execution time based on the initial time and the interval.
    /// - Parameter timeInterval: The time interval for scheduling.
    /// - Returns: The next execution time.
    private func calculateNextExecutionTime(with timeInterval: TimeInterval) async -> TimeInterval {
        // Get the initial time from UserDefaults
        let initialTime: TimeInterval = await getInitialTimeFromUserDefaults()
        
        // Get the current time
        let now: TimeInterval = Date().timeIntervalSince1970
        
        // Calculate the elapsed time since the initial time
        let elapsedTime: TimeInterval = now - initialTime
        
        // Determine how many complete intervals have passed
        let intervalsPassed: Int = .init(elapsedTime / timeInterval)
        
        // Calculate the next execution time
        let nextExecutionTime: TimeInterval = initialTime + timeInterval * Double(intervalsPassed + 1)
        
        return nextExecutionTime
    }
}
