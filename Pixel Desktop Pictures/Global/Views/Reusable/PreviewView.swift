//
//  PreviewView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-27.
//

import SwiftUI

struct PreviewView<T: View>: View {
    // MARK: - PROPERTIES
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
        .frame(width: TabItems.allWindowWidth)
        .background(Color.windowBackground)
        .environment(TabsViewModel())
        .environment(MainTabViewModel())
        .environment(CollectionsViewModel())
        .environment(RecentsTabViewModel())
    }
}

// MARK: - PREVIEWS
#Preview(" Preview View") {
    PreviewView { Color.debug }
}