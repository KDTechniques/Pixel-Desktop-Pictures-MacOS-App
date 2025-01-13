//
//  CollectionsTabView.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUI

struct CollectionsTabView: View {
    // MARK: - PROPERTIES
    @Environment(CollectionsTabViewModel.self) private var collectionsTabVM
    @State private var scrollPosition: ScrollPosition = .init()
    
    // MARK: - BODY
    var body: some View {
        TabContentWithWindowErrorView(tab: .collections) {
            Group {
                if !collectionsTabVM.collectionItemsArray.isEmpty {
                    CollectionsVGridScrollView(scrollPosition: $scrollPosition)
                } else {
                    WindowErrorView(model: CollectionsTabWindowErrorModel.collectionsViewModelInitializationFailed)
                }
            }
            .background(Color.windowBackground)
            .onChange(of: collectionsTabVM.collectionItemsArray.count) {
                collectionsTabVM.onCollectionItemsArrayChange(oldValue: $0, newValue: $1, scrollPosition: $scrollPosition)
            }
        }
    }
}

// MARK: - PREVIEWS
#Preview("Collections Grid Tab View") {
    @Previewable @State var collectionsTabVM: CollectionsTabViewModel = .init(
        apiAccessKeyManager: .init(),
        collectionModelSwiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)),
        imageQueryURLModelSwiftDataManager: .init(swiftDataManager: try! .init(appEnvironment: .mock)),
        errorPopupVM: .init()
    )
    
    PreviewView {
        CollectionsVGridScrollView(scrollPosition: .constant(.init(edge: .top)))
            .environment(collectionsTabVM)
            .onFirstAppearViewModifier {
                collectionsTabVM.collectionItemsArray = try! CollectionModel.getDefaultCollectionsArray()
            }
    }
}
