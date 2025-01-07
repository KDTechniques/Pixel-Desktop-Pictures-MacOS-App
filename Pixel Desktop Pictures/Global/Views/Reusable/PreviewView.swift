//
//  PreviewView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUI

struct PreviewView<T: View>: View {
    // MARK: - PROPERTIES
    @Environment(\.appEnvironment) private var appEnvironment
    let content: T
    
    // MARK: - INITIALIZER
    init(@ViewBuilder content: () -> T) {
        self.content = content()
    }
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            content
        }
        .frame(width: TabItemsModel.allWindowWidth)
        .background(Color.windowBackground)
        .environment(TabsViewModel())
        .environment(MainTabViewModel())
        .environment(CollectionsViewModel())
        .environment(RecentsTabViewModel())
        .environment(SettingsTabViewModel(appEnvironment: .mock))
        .environment(APIAccessKeyManager())
    }
}

// MARK: - PREVIEWS
#Preview(" Preview View") {
    PreviewView { Color.debug }
}
