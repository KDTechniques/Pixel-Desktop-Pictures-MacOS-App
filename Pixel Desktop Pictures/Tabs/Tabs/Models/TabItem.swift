//
//  TabItem.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-23.
//

import SwiftUICore

enum TabItem: String, CaseIterable {
    case main, recents, collections, settings
    
    @ViewBuilder
    var content: some View {
        switch self {
        case .main:
            MainTabView()
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
    static let tabHeaderHeight: CGFloat = 54
    
    var contentHeight: CGFloat {
        switch self {
        case .main, .settings:
            return CGFloat.nan // Placeholder for dynamic sizing via GeometryReader
        case .recents:
            return (VGridValuesModel.height*4) + (VGridValuesModel.spacing*3) + (VGridValuesModel.spacing/2)
        case .collections:
            return (VGridValuesModel.height*3) + (VGridValuesModel.spacing*2)
        }
    }
    
    static let bottomPopupAnimation: Animation = .smooth(duration: 0.4)
}
