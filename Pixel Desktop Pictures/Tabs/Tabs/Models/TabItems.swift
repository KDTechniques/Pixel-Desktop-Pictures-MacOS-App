//
//  TabItems.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUICore

enum TabItems: CaseIterable {
    case main, recents, collections, settings
    
    @ViewBuilder
    var content: some View {
        switch self {
        case .main:
//            MainTabView()
            SwiftUIView()
        case .recents:
            RecentsTabView()
        case .collections:
            CollectionsTabView()
        case .settings:
            SettingsTabView()
        }
    }
    
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
        case .main, .settings:
            return CGFloat.nan // Placeholder for dynamic sizing via GeometryReader
        case .recents:
            return (VGridValues.height*4) + (VGridValues.spacing*3) + (VGridValues.spacing/2)
        case .collections:
            return (VGridValues.height*3) + (VGridValues.spacing*2)
        }
    }
}
