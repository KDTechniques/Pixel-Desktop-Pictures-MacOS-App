//
//  CollectionsTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct CollectionsTabView: View {
    // MARK: - INJECTED PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    
    // MARK: - ASSIGNED PROPERTIES
    @State private var scrollPosition: ScrollPosition = .init()
    
    // MARK: - BODY
    var body: some View {
        TabContentWithWindowErrorView(tab: .collections) {
            Group {
                if !collectionsTabVM.collectionsArray.isEmpty {
                    CollectionsVGridScrollView(scrollPosition: $scrollPosition)
                } else {
                    WindowErrorView(model: CollectionsTabWindowError.collectionsTabViewModelInitializationFailed)
                }
            }
            .background(Color.windowBackground)
            .onChange(of: collectionsTabVM.collectionsArray.count) {
                collectionsTabVM.onCollectionItemsArrayChange(oldValue: $0, newValue: $1, scrollPosition: $scrollPosition)
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("Collections Grid Tab View") {
    @Previewable @State var collectionsTabVM: CollectionsTabViewModel = .init(apiAccessKeyManager: .init())
    
    PreviewView {
        CollectionsVGridScrollView(scrollPosition: .constant(.init(edge: .top)))
            .environment(collectionsTabVM)
            .onFirstAppearViewModifier {
                collectionsTabVM.setCollectionsArray(try! Collection.getDefaultCollectionsArray())
            }
    }
}
