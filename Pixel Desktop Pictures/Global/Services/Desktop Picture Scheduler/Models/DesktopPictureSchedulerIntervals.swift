//
//  DesktopPictureSchedulerIntervals.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

enum DesktopPictureSchedulerIntervals: String, CaseIterable, DesktopPictureSchedulerIntervalsProtocol {
    case hourly, daily, weekly
    
    var timeIntervalName: String {
        return self.rawValue.capitalized
    }
    
    var timeInterval: TimeInterval {
        switch self {
        case .hourly:
            return 60 * 60  // 1 hour in seconds
        case .daily:
            return 24 * 60 * 60  // 1 day in seconds
        case .weekly:
            return 7 * 24 * 60 * 60  // 1 week in seconds
        }
    }
    
    static var defaultTimeInterval: TimeInterval {
        return DesktopPictureSchedulerIntervals.daily.timeInterval
    }
}
