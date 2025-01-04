//
//  UserDefaultKeys.swift
//  DailyDesktopPicture
//
//  Created by Kavinda Dilshan on 2024-12-19.
//

import Foundation

// Note: Do not change the following cases as it could result in data, settings, and config losses.
enum UserDefaultKeys: String {
    case hasFirstLaunchKey
    case launchAtLoginKey
    case endpointSelectionKey
    case selectedCollectionsKey
    case apiAccessKey
    case apiAccessKeyStatusKey
    case timeIntervalSelectionKey
    case executionTimeIntervalSince1970Key
    case currentDesktopPictureFileURLStringKey
}
