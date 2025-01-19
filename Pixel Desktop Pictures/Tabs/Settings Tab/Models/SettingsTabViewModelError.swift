//
//  SettingsTabViewModelError.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-20.
//

import Foundation

enum SettingsTabViewModelError: LocalizedError {
    case failedToInitializeSettingsTabViewModel(_ error: Error)
    case failedToSaveUpdateIntervalsToUserDefaults(_ error: Error)
    case failedToGetSettingsFromUserDefaults(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case.failedToInitializeSettingsTabViewModel(let error):
            return "❌: Failed to initialize `Settings Tab View Model`."
        case .failedToSaveUpdateIntervalsToUserDefaults(let error):
            return "❌: Failed to save update Interval to user defaults. \(error.localizedDescription)"
        case .failedToGetSettingsFromUserDefaults(let error):
            return "❌: Failed to get settings from user defaults. \(error.localizedDescription)"
        }
    }
}
