//
//  RecentsTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct RecentsTabView: View {
    // MARK: - PROPERTIES
    @Environment(TabsViewModel.self) private var tabsVM
    @State private var recentsTabVM: RecentsTabViewModel = .init()
    let vGridValues = VGridValues.self
    
    // MARK: - BODY
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: vGridValues.columns, spacing: vGridValues.spacing) {
                ForEach(0...20, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.debug)
                        .frame(height: vGridValues.height)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .frame(height: TabItems.recents.contentHeight)
        .setTabContentHeightToTabsViewModel(vm: tabsVM)
        .environment(recentsTabVM)
    }
}

// MARK: - PREVIEWS
#Preview("Image Grid View") {
    PreviewView { RecentsTabView() }
}
