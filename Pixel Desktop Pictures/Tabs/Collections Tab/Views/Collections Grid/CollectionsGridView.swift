//
//  CollectionsGridView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct PopOverPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CollectionsGridView: View {
    // MARK: - PROPERTIES
    @State var collectionsVM: CollectionsViewModel = .init()
    @State private var popOverHeight: CGFloat = 0
    let vGridValues = VGridValues.self
    
    // MARK: - BODY
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .padding()
            
            ScrollView(.vertical) {
                LazyVGrid(columns: vGridValues.columns, spacing: vGridValues.spacing) {
                    ForEach(collectionsVM.collectionVGridItemsArray, id: \.self) { item in
                        CollectionsVGridImageView(item: item)
                        CollectionsVGridPlusFrameButtonView(id: item.id)
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .overlay { CollectionsGridPopupBackgroundView() }
            .overlay(alignment: .bottom) {
                AddNewCollectionView()
                    .getGeometryHeight($popOverHeight)
                    .offset(y: collectionsVM.isPresentedPopup ? 0 : popOverHeight)
                    .animation(collectionsVM.popOverAnimation.0, value: collectionsVM.popOverAnimation.1)
            }
        }
        .background(Color.windowBackground)
        .onTapGesture { handleTap() }
        .environment(collectionsVM)
    }
}

// MARK: - PREVIEWS
#Preview("Collections Grid View") {
    let utilities = Utilities.self
    CollectionsGridView()
        .frame(width: utilities.allWindowWidth, height: utilities.collectionsTabWindowHeight)
        .background(Color.windowBackground)
}

// MARK: - EXTENSIONS
extension CollectionsGridView {
    // MARK: - Handle Tap
    private func handleTap() {
        collectionsVM.presentPopup(false)
    }
}

extension View {
    // MARK: - Get Geometry Height
    fileprivate func getGeometryHeight(_ height: Binding<CGFloat>) -> some View {
        self
            .background {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: PopOverPreferenceKey.self, value: geo.frame(in: .local).height)
                }
                .onPreferenceChange(PopOverPreferenceKey.self) { value in
                    height.wrappedValue = value
                }
            }
    }
}
