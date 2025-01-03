//
//  RecentsTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct RecentsTabView: View {
    // MARK: - PROPERTIES
    @State private var recentsTabVM: RecentsTabViewModel = .init()
    let vGridValues = VGridValuesModel.self
    
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
        .frame(height: TabItemsModel.recents.contentHeight)
        .setTabContentHeightToTabsViewModelViewModifier
        .environment(recentsTabVM)
    }
}

// MARK: - PREVIEWS
#Preview("Image Grid View") {
    PreviewView { RecentsTabView() }
}
