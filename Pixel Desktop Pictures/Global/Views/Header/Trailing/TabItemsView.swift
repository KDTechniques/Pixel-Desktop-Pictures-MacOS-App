//
//  TabItemsView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct TabItemsView: View {
    
    let tabItems = TabItems.self
    
    var body: some View {
        HStack {
            Image(systemName: tabItems.main.systemImage)
                .foregroundStyle(.tabInactive)
            
            Image(systemName: tabItems.recents.systemImage)
            
            Image(systemName: tabItems.collections.systemImage)
            
            Image(systemName: tabItems.settings.systemImage)
                .foregroundStyle(.tabActive)
        }
        .font(.title2)
        .foregroundStyle(.tabInactive)
    }
}

#Preview("Tab Items View") {
    TabItemsView()
        .padding()
        .frame(width: Utilities.allWindowWidth)
        .background(Color.windowBackground)
}
