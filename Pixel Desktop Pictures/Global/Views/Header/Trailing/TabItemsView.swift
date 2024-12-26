//
//  TabItemsView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct TabItemsView: View {
    // MARK: - BODY
    var body: some View {
        HStack {
            ForEach(TabItems.allCases, id: \.self) { tab in
                TabButtonView(tab: tab)
            }
        }
        .font(.title2)
        .buttonStyle(.plain)
    }
}

// MARK: - PREVIEWS
#Preview("Tab Items View") {
    TabItemsView()
        .padding()
        .frame(width: TabItems.allWindowWidth)
        .background(Color.windowBackground)
        .environment(TabsViewModel())
}
