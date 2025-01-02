//
//  MockDesktopPictureSchedulerIntervalsModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

enum MockDesktopPictureSchedulerIntervalsModel: String, CaseIterable, DesktopPictureSchedulerIntervalsProtocol {
    case hourly, daily, weekly
    
    var timeIntervalName: String {
        return self.rawValue.capitalized
    }
    
    // Note: Do not test for less than 10 minutes, as it is advised for `Activities Occurring in Intervals of 10 Minutes or More`.
    /// 1 minute is the minimum value that can be used; otherwise, the scheduler may not work properly.
    /// A value greater than 1 minute is always fine for testing purposes, but in a production environment, 10 minutes is the recommended minimum value.
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
