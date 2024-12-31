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
            return 1 * 60 // 1 minute to mimic 1 hour
        case .daily:
            return 2 * 60 // 2 minutes to mimic 24 hours
        case .weekly:
            return 3 * 60 // 3 minutes to mimic a week
        }
    }
    
    static var defaultTimeInterval: TimeInterval {
        return self.daily.timeInterval
    }
}
