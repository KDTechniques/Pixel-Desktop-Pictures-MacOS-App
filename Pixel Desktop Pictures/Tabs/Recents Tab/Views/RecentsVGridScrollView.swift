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
    private let vGridValues = VGridValues.self
    @State private var scrollID: String = UUID().uuidString
    @State private var direction: UnitPoint?
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: vGridValues.columns, spacing: vGridValues.spacing) {
                    ForEach(recentsTabVM.recentsArray, id: \.id) { recentItem in
                        RecentsVGridImageView(item: recentItem)
                    }
                }
                .padding([.horizontal, .bottom])
                .id(scrollID)
            }
            .scrollPosition(.constant(.init(id: scrollID)), anchor: direction)
            
            ScrollPageUpNDownView(scrollID: $scrollID, direction: $direction, key: .pageUp)
            ScrollPageUpNDownView(scrollID: $scrollID, direction: $direction, key: .pageDown)
        }
    }
}

// MARK: - PREVIEWS
#Preview("Recents VGrid Scroll View") {
    RecentsVGridScrollView()
        .previewModifier
}
