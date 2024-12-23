//
//  TabItems.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import Foundation

enum TabItems {
    case main, recents, collections, settings
    
    var systemImage: String {
        switch self {
        case .main:
            return "photo.on.rectangle.angled.fill"
        case .recents:
            return "clock.fill"
        case .collections:
            return "square.grid.2x2.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}
