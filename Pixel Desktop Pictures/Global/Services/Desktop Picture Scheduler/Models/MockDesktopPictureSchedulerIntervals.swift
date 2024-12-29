//
//  MockDesktopPictureSchedulerIntervals.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

enum MockDesktopPictureSchedulerIntervals: String, CaseIterable, DesktopPictureSchedulerIntervalsProtocol {
    case hourly, daily, weekly
    
    var timeIntervalName: String {
        return self.rawValue.capitalized
    }
    
    // Note: Do not test for less than 10 minutes, as it is advised for `Activities Occurring in Intervals of 10 Minutes or More`.
    var timeInterval: TimeInterval {
        switch self {
        case .hourly:
            return 60 * 15 // 15 minutes to mimic 1 hour
        case .daily:
            return 60 * 20 // 20 minutes to mimic 24 hours
        case .weekly:
            return 60 * 30 // 30 minutes to mimic a week
        }
    }
    
    static var defaultTimeInterval: TimeInterval {
        return DesktopPictureSchedulerIntervals.daily.timeInterval
    }
}
