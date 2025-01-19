//
//  RecentsVGridScrollView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2025-01-19.
//

import SwiftUI

struct RecentsVGridScrollView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(RecentsTabViewModel.self) private var recentsTabVM
    
    // MARK: - ASSGNED PROPERTIES
    let vGridValues: VGridValuesModel.Type = VGridValuesModel.self
    
    // MARK: - BODY
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: vGridValues.columns, spacing: vGridValues.spacing) {
                ForEach(recentsTabVM.recentsArray, id: \.id) { recentItem in
                    RecentsVGridImageView(item: recentItem)
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

// MARK: - PREVIEWS
#Preview("Recents VGrid Scroll View") {
    RecentsVGridScrollView()
        .previewModifier
}
