//
//  DesktopPictureSchedulerErrorModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-31.
//

import Foundation

enum DesktopPictureSchedulerErrorModel: LocalizedError {
    case activitySchedulingFailed
    case executionTimeProcessingFailed
    case taskDeallocated
    
    var errorDescription: String? {
        switch self {
        case .activitySchedulingFailed:
            return "Error: Unable to initialize `NSBackgroundActivityScheduler` Task."
        case .executionTimeProcessingFailed:
            return "Error: Unable to calculate, schedule, and save the execution time interval since 1970."
        case .taskDeallocated:
            return "Error: `NSBackgroundActivityScheduler` Task is Deallocated on `DesktopPictureScheduler` actor."
        }
    }
}
