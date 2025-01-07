//
//  DesktopPictureSchedulerIntervalsModel.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-28.
//

import Foundation

enum DesktopPictureSchedulerIntervalsModel: String, Codable, CaseIterable {
    case hourly, daily, weekly
    
    var timeIntervalName: String {
        return self.rawValue.capitalized
    }
    
    func timeInterval(environment: AppEnvironmentModel) -> TimeInterval {
        switch environment {
        case .production:
            switch self {
            case .hourly:
                return 60 * 60  // 1 hour in seconds
            case .daily:
                return 24 * 60 * 60  // 1 day in seconds
            case .weekly:
                return 7 * 24 * 60 * 60  // 1 week in seconds
            }
        case .mock:
            // Note: Do not test for less than 10 minutes, as it is advised for `Activities Occurring in Intervals of 10 Minutes or More`.
            /// 1 minute is the minimum value that can be used; otherwise, the scheduler may not work properly.
            /// A value greater than 1 minute is always fine for testing purposes, but in a production environment, 10 minutes is the recommended minimum value.
            switch self {
            case .hourly:
                return 1 * 60 // 1 minute to mimic 1 hour
            case .daily:
                return 2 * 60 // 2 minutes to mimic 24 hours
            case .weekly:
                return 3 * 60 // 3 minutes to mimic a week
            }
        }
    }
    
    static let defaultTimeInterval: Self = .daily
}
