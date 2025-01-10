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
    @Environment(CollectionsViewModel.self) private var collectionsVM
    @State private var collectionCreationPopOverHeight: CGFloat = 0
    @State private var collectionUpdatePopOverHeight: CGFloat = 0
    @State private var scrollPosition: ScrollPosition = .init()
    let vGridValues = VGridValuesModel.self
    let nonScrollableItemsCount: Int = 8
    
    // MARK: - BODY
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: vGridValues.columns, spacing: vGridValues.spacing) {
                ForEach(collectionsVM.collectionItemsArray, id: \.self) { item in
                    CollectionsVGridPlusFrameButtonView(collectionName: item.collectionName)
                    CollectionsVGridImageView(item: item)
                }
            }
            .padding(.horizontal)
        }
        .scrollPosition($scrollPosition)
        .scrollDisabled(collectionsVM.collectionItemsArray.count <= nonScrollableItemsCount)
        .frame(height: TabItemsModel.collections.contentHeight)
        .padding(.bottom)
        .overlay { CollectionsGridPopupBackgroundView() }
        .overlay(alignment: .bottom) { collectionCreationPopOver }
        .overlay(alignment: .bottom) { collectionUpdatePopOver }
        .background(Color.windowBackground)
        .setTabContentHeightToTabsViewModelViewModifier(from: .collections)
        .onChange(of: collectionsVM.collectionItemsArray.count) {
            onCollectionItemsArrayChange(oldValue: $0, newValue: $1)
        }
    }
}

// MARK: - PREVIEWS
#Preview("Collections Grid Tab View") {
    PreviewView { CollectionsTabView() }
}

// MARK: - EXTENSIONS
extension CollectionsTabView {
    // MARK: - Collection Creation PopOver
    private var collectionCreationPopOver: some View {
        AddNewCollectionView()
            .getGeometryHeight($collectionCreationPopOverHeight)
            .offset(y: collectionsVM.popOverItem == (true, .collectionCreationPopOver) ? 0 : collectionCreationPopOverHeight)
    }
    
    // MARK: - Collection Update PopOver
    private var collectionUpdatePopOver: some View {
        UpdateCollectionView()
            .getGeometryHeight($collectionUpdatePopOverHeight)
            .offset(y: collectionsVM.popOverItem == (true, .collectionUpdatePopOver) ? 0 : collectionUpdatePopOverHeight)
    }
    
    // MARK: FUNCTIONS
    
    // MARK: - On Collection Items Array Change
    private func onCollectionItemsArrayChange(oldValue: Int, newValue: Int) {
        guard oldValue != 0, oldValue < newValue else { return }
        withAnimation { scrollPosition.scrollTo(edge: .bottom) }
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
