//
//  CollectionsTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct CollectionsTabView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsViewModel.self) private var collectionsVM
    @State private var scrollPosition: ScrollPosition = .init()
    
    // MARK: - BODY
    var body: some View {
        TabContentWithWindowErrorView(tab: .collections) {
            Group {
                if !collectionsVM.collectionItemsArray.isEmpty {
                    CollectionsVGridScrollView(scrollPosition: $scrollPosition)
                } else {
                    WindowErrorView(model: CollectionsTabWindowErrorModel.collectionsViewModelInitializationFailed)
                }
            }
            .background(Color.windowBackground)
            .onChange(of: collectionsVM.collectionItemsArray.count) {
                collectionsVM.onCollectionItemsArrayChange(oldValue: $0, newValue: $1, scrollPosition: $scrollPosition)
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("Collections Grid Tab View") {
    @Previewable @State var collectionsVM: CollectionsViewModel = .init(
        apiAccessKeyManager: .init(),
        swiftDataManager: try! .init(swiftDataManager: .init(appEnvironment: .mock)),
        errorPopupVM: .init()
    )
    
    PreviewView {
        CollectionsVGridScrollView(scrollPosition: .constant(.init(edge: .top)))
            .environment(collectionsVM)
            .onFirstAppearViewModifier {
                collectionsVM.collectionItemsArray = try! CollectionModel.getDefaultCollectionsArray()
            }
    }
}
