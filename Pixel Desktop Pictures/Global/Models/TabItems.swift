//
//  TabItems.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import Foundation

enum TabItems: CaseIterable {
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
    
    static let allWindowWidth: CGFloat = 375
    
    var contentHeight: CGFloat {
        switch self {
        case .main:
            return .infinity
        case .recents:
            return {
                let values = VGridValues.self
                return (values.height*4) + (values.spacing*3) + (values.spacing/2)
            }()
        case .collections:
            return {
                let values = VGridValues.self
                return (values.height*3) + (values.spacing*2)
            }()
        case .settings:
            return .infinity
        }
    }
}
