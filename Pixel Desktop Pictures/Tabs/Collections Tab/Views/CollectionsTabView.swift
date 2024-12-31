//
//  CollectionsTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

fileprivate struct PopOverPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct CollectionsTabView: View {
    // MARK: - PROPERTIES
    @State var collectionsVM: CollectionsViewModel = .init()
    @State private var popOverHeight: CGFloat = 0
    let vGridValues = VGridValues.self
    
    // MARK: - BODY
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: vGridValues.columns, spacing: vGridValues.spacing) {
                ForEach(collectionsVM.collectionVGridItemsArray, id: \.self) { item in
                    CollectionsVGridImageView(item: item)
                    CollectionsVGridPlusFrameButtonView(id: item.id)
                }
            }
            .padding(.horizontal)
        }
        .scrollDisabled(collectionsVM.collectionVGridItemsArray.count <= 8)
        .frame(height: TabItems.collections.contentHeight)
        .padding(.bottom)
        .overlay { CollectionsGridPopupBackgroundView() }
        .overlay(alignment: .bottom) { popup }
        .background(Color.windowBackground)
        .setTabContentHeightToTabsViewModelViewModifier
        .onTapGesture { handleTap() }
        .environment(collectionsVM)
    }
}

// MARK: - PREVIEWS
#Preview("Collections Grid Tab View") {
    PreviewView { CollectionsTabView() }
}

// MARK: - EXTENSIONS
extension CollectionsTabView {
    // MARK: - popup
    private var popup: some View {
        AddNewCollectionView()
            .getGeometryHeight($popOverHeight)
            .offset(y: collectionsVM.isPresentedPopup ? 0 : popOverHeight)
            .animation(collectionsVM.popOverAnimation.0, value: collectionsVM.popOverAnimation.1)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - Handle Tap
    private func handleTap() {
        collectionsVM.presentPopup(false)
    }
}

fileprivate extension View {
    // MARK: - Get Geometry Height
    func getGeometryHeight(_ height: Binding<CGFloat>) -> some View {
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
